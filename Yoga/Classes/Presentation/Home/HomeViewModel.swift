//
//  HomeViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import RxSwift
import RxCocoa

final class HomeViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var didTapPlanDay = PublishRelay<Date>()
    
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var homeKit = makeHomeKit()
    private lazy var skillLevels = makeSkillLevels()
    private lazy var drillCategories = makeDrillCategories()
    private lazy var workoutCovers = makeWorkoutCovers()
    private lazy var planDay = makePlanDay()
    
    private lazy var contentManager = ContentManager()
    private lazy var drillManager = DrillManager()
    private lazy var workoutManager = WorkoutManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension HomeViewModel {
    func makeElements() -> Driver<[HomeTableElement]> {
        Driver
            .combineLatest(homeKit, skillLevels, drillCategories, workoutCovers, planDay)
            .map { [weak self] homeKit, skillLevels, drillCategories, workoutCovers, planDay -> [HomeTableElement] in
                guard let self = self, let homeKit = homeKit else {
                    return []
                }
                
                var result = [HomeTableElement]()
                
                let stats = self.statsElements(homeKit: homeKit, skillLevels: skillLevels)
                result.append(contentsOf: stats)
                
                let dailyPicks = self.dailyPicksElements(
                    homeKit: homeKit,
                    skillLevels: skillLevels
                )
                result.append(contentsOf: dailyPicks)
                
                let plan = self.planElements(
                    homeKit: homeKit,
                    planDay: planDay
                )
                result.append(contentsOf: plan)
                
                let planTrainings = self.planTrainingsElements(
                    homeKit: homeKit,
                    skillLevels: skillLevels,
                    planDay: planDay
                )
                result.append(contentsOf: planTrainings)
                
                let drillCategoriesElements: [HomeTableElement] = [
                    .offset(40.scale),
                    .drillCategories(drillCategories)
                ]
                result.append(contentsOf: drillCategoriesElements)
                
                let drills = self.drillsElements(
                    homeKit: homeKit,
                    skillLevels: skillLevels
                )
                result.append(contentsOf: drills)
                
                let workouts = self.workoutsElements(
                    homeKit: homeKit,
                    workoutCovers: workoutCovers,
                    skillLevels: skillLevels
                )
                result.append(contentsOf: workouts)
                
                return result
            }
    }
    
    func makeHomeKit() -> Driver<HomeKit?> {
        let triggers = Signal<Void>.merge(
            WorkoutMediator.shared.didLogProgress.map { _ in Void() },
            WorkoutMediator.shared.didSchedule.map { _ in Void() },
            DrillMediator.shared.didLogProgress.map { _ in Void() },
            DrillMediator.shared.didSchedule.map { _ in Void() },
            PlanMediator.shared.didReinit.map { _ in Void() },
            ProfileMediator.shared.skillLevelIdChange.map { _ in Void() },
            ProfileMediator.shared.drillsIdsChange.map { _ in Void() }
        )
        
        return triggers
            .startWith(Void())
            .flatMapLatest { [weak self] void -> Driver<HomeKit?> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<HomeKit?> {
                    self.contentManager
                        .obtainHomeKit()
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .trackActivity(self.activity)
                    .asDriver(onErrorJustReturn: nil)
            }
    }
    
    func makeSkillLevels() -> Driver<[SkillLevel]> {
        contentManager
            .obtainLevels(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeDrillCategories() -> Driver<[DrillCategory]> {
        drillManager
            .obtainDrillCategories(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeWorkoutCovers() -> Driver<[WorkoutCover]> {
        workoutManager
            .obtainWorkoutCovers(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makePlanDay() -> Driver<Date> {
        didTapPlanDay
            .startWith(Date())
            .asDriver(onErrorDriveWith: .never())
    }
}

// MARK: Private (Additional)
private extension HomeViewModel {
    func statsElements(homeKit: HomeKit, skillLevels: [SkillLevel]) -> [HomeTableElement] {
        guard let skillLevel = skillLevels.first(where: { $0.id == homeKit.levelId }) else {
            return []
        }
        
        let element = HomeStatsElement(
            score: homeKit.score,
            skillLevel: skillLevel
        )
        
        return [.stats(element)]
    }
    
    func dailyPicksElements(
        homeKit: HomeKit,
        skillLevels: [SkillLevel]
    ) -> [HomeTableElement] {
        let workouts = homeKit.dailyWorkouts.compactMap { workout -> DailyPicksElement? in
            guard let skillLevel = skillLevels.first(where: { $0.id == workout.levelId }) else {
                return nil
            }
            
            return DailyPicksElement(
                workout: workout,
                skillLevel: skillLevel
            )
        }
        
        if workouts.isEmpty {
            return []
        }
        
        return [
            .offset(32.scale),
            .title(.large("Home.DailyPicks".localized)),
            .offset(16.scale),
            .dailyPicks(workouts)
        ]
    }
    
    func planElements(
        homeKit: HomeKit,
        planDay: Date
    ) -> [HomeTableElement] {
        let calendar = Calendar.current
        let today = Date()
        let todayDayOfWeek = calendar.component(.weekday, from: today)
        
        guard
            let weekdaysRange = calendar.range(of: .weekday, in: .weekOfYear, for: today),
            let index = weekdaysRange.firstIndex(of: calendar.firstWeekday)
        else {
            return []
        }
        
        let weekdays = weekdaysRange[index...] + weekdaysRange[..<index].map { $0 + weekdaysRange.count }
        let dates = weekdays.compactMap { calendar.date(byAdding: .day, value: $0 - todayDayOfWeek, to: today) }
        
        let models = dates.map { day -> PlanWeekDayButton.Model in
            PlanWeekDayButton.Model(
                day: day,
                isCurrentDay: calendar.isDateInToday(day),
                isSelected: day.isEqualByDays(with: planDay),
                planStatus: homeKit.plan.first(where: { $0.day.isEqualByDays(with: day) })?.status
            )
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        formatter.dateStyle = .medium
        formatter.doesRelativeDateFormatting = true
        
        let planDayLocalized = formatter.string(from: planDay)
        let planDayTitle = String(format: "Home.Schedule".localized, planDayLocalized)
        
        return [
            .offset(40.scale),
            .title(.large(planDayTitle)),
            .offset(16.scale),
            .plan(models)
        ]
    }
    
    func planTrainingsElements(
        homeKit: HomeKit,
        skillLevels: [SkillLevel],
        planDay: Date
    ) -> [HomeTableElement] {
        guard let plan = homeKit.plan.first(where: { $0.day.isEqualByDays(with: planDay) }) else {
            return [
                .offset(16.scale),
                .noTrainings,
                .offset(16.scale),
                .addTraining
            ]
        }
        
        let baseDrills = plan.drills.filter { $0.status != .completed }
        let completedDrills = plan.drills.filter { $0.status == .completed }
        
        let baseWorkout = plan.workouts.filter { $0.status != .completed }
        let completedWorkouts = plan.workouts.filter { $0.status == .completed }
        
        var result = [HomeTableElement]()
        
        func fill(from drills: [PlanDrill]) {
            drills.enumerated().forEach { index, planDrill in
                guard let skillLevel = skillLevels.first(where: { $0.id == planDrill.levelId }) else {
                    return
                }
                
                let element = HomePlanTrainingElement(
                    training: .drill(planDrill),
                    skillLevel: skillLevel
                )
                result.append(contentsOf: [
                    .offset(16.scale),
                    .planTraining(element)
                ])
            }
        }
        
        func fill(from workouts: [PlanWorkout]) {
            workouts.enumerated().forEach { index, planWorkout in
                guard let skillLevel = skillLevels.first(where: { $0.id == planWorkout.levelId }) else {
                    return
                }
                
                let element = HomePlanTrainingElement(
                    training: .workout(planWorkout),
                    skillLevel: skillLevel
                )
                result.append(contentsOf: [
                    .offset(16.scale),
                    .planTraining(element)
                ])
            }
        }
        
        if !baseDrills.isEmpty {
            fill(from: baseDrills)
        }
        if !baseWorkout.isEmpty {
            fill(from: baseWorkout)
        }
        
        if !completedDrills.isEmpty {
            result.append(contentsOf: [
                .offset(24.scale),
                .title(.small("Home.Completed".localized))
            ])
            
            fill(from: completedDrills)
        }
        if !completedWorkouts.isEmpty {
            if completedDrills.isEmpty {
                result.append(contentsOf: [
                    .offset(24.scale),
                    .title(.small("Home.Completed".localized))
                ])
            }
            
            fill(from: completedWorkouts)
        }
        
        result.append(contentsOf: [
            .offset(24.scale),
            .addTraining
        ])
        
        return result
    }
    
    func drillsElements(
        homeKit: HomeKit,
        skillLevels: [SkillLevel]
    ) -> [HomeTableElement] {
        guard !homeKit.tryDrills.isEmpty else {
            return []
        }
        
        var result: [HomeTableElement] = [
            .offset(43.scale),
            .tryDrillsTitle("Home.TryDrills".localized),
            .offset(19.scale)
        ]
        
        homeKit.tryDrills.enumerated().forEach { index, drill in
            guard let skillLevel = skillLevels.first(where: { $0.id == drill.skillLevelId }) else {
                return
            }
            
            let element = HomeDrillElement(
                drill: drill,
                skillLevel: skillLevel
            )
            result.append(.drill(element))
            
            if (homeKit.tryDrills.count - 1) != index {
                result.append(.offset(16.scale))
            }
        }
        
        return result
    }
    
    func workoutsElements(
        homeKit: HomeKit,
        workoutCovers: [WorkoutCover],
        skillLevels: [SkillLevel]
    ) -> [HomeTableElement] {
        let workoutElements = workoutCovers.compactMap { workoutCover -> HomeWorkoutElement? in
            guard let skillLevel = skillLevels.first(where: { $0.id == homeKit.levelId }) else {
                return nil
            }
            
            return HomeWorkoutElement(
                workout: workoutCover,
                skillLevel: skillLevel
            )
        }.prefix(3)
        
        guard !workoutElements.isEmpty else {
            return []
        }
        
        return [
            .offset(43.scale),
            .workoutsTitle("Home.ImproveYourFitness".localized),
            .offset(19.scale),
            .workouts(Array(workoutElements))
        ]
    }
}
