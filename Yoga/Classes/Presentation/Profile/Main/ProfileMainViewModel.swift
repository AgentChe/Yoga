//
//  ProfileMainViewModel.swift
//  Soccer
//
//  Created by Виталий Загороднов on 25.04.2023.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileMainViewModel {
    enum Route {
        case details
        case drill(PlanDrill)
        case workout(PlanWorkout)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var activity = RxActivityIndicator()
    lazy var didTapPlanDay = PublishRelay<Date>()
    lazy var didSelectCell = PublishRelay<ProfileMainTableElement>()
    lazy var elements = makeElements()
    lazy var route = makeRoute()
    
    private lazy var homeKit = makeHomeKit()
    private lazy var skillLevels = makeSkillLevels()
    private lazy var planDay = makePlanDay()
    private lazy var plan = makePlan()
    
    private lazy var planManager = PlanManager()
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

private extension ProfileMainViewModel {
    func makeRoute() -> Signal<Route> {
        didSelectCell
            .compactMap { element -> Route? in
                switch element {
                case .profile:
                    return .details
                case .planTraining(let element):
                    switch element.training {
                    case .drill(let drill):
                        return .drill(drill)
                    case .workout(let workout):
                        return .workout(workout)
                    }
                default:
                    return nil
                }
            }
            .asSignal(onErrorSignalWith: .never())
    }
    
    func makeElements() -> Driver<[ProfileMainTableElement]> {
        Driver.combineLatest(homeKit, skillLevels, planDay, plan)
            .map { [weak self] homeKit, skillLevels, planDay, plan in
                guard let self, let homeKit else { return [] }
                var result = [ProfileMainTableElement]()
                
                result.append(.profile)
                
                if let level = skillLevels.first(where: { $0.id == homeKit.levelId }) {
                    result.append(.offset(40.scale))
                    result.append(.progress(percent: homeKit.score, level: level.name))
                }
                
                result.append(.offset(40.scale))
                result.append(.calendar(plan))
                
                let planTrainings = self.planTrainingsElements(
                    homeKit: homeKit,
                    skillLevels: skillLevels,
                    planDay: planDay
                )
                
                result.append(contentsOf: planTrainings)
                
                result.append(.offset(40.scale))
                result.append(.stats(homeKit.trainingCompletedSeconds))
                result.append(.offset(40.scale))
                
                return result
            }
    }
    
    func makePlan() -> Driver<[PlanOnDay]> {
        func source() -> Single<[PlanOnDay]> {
            self.planManager.obtainPlan()
        }
        
        func trigger(error: Error) -> Observable<Void> {
            guard let tryAgain = self.tryAgain?(error) else {
                return .empty()
            }
            
            return tryAgain
        }
        
        return self.observableRetrySingle
            .retry(source: source, trigger: trigger)
            .trackActivity(self.activity)
            .asDriver(onErrorJustReturn: [])
    }
    
    func planTrainingsElements(
        homeKit: HomeKit,
        skillLevels: [SkillLevel],
        planDay: Date
    ) -> [ProfileMainTableElement] {
        guard let plan = homeKit.plan.first(where: { $0.day.isEqualByDays(with: planDay) }) else {
            return [
                .offset(16.scale),
                .noTrainings
            ]
        }
        
        let baseDrills = plan.drills.filter { $0.status != .completed }
        let completedDrills = plan.drills.filter { $0.status == .completed }
        
        let baseWorkout = plan.workouts.filter { $0.status != .completed }
        let completedWorkouts = plan.workouts.filter { $0.status == .completed }
        
        var result = [ProfileMainTableElement]()
        
        func fill(from drills: [PlanDrill]) {
            drills.enumerated().forEach { index, planDrill in
                guard let skillLevel = skillLevels.first(where: { $0.id == planDrill.levelId}) else {
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
            fill(from: completedDrills)
        }
        if !completedWorkouts.isEmpty {
            fill(from: completedWorkouts)
        }

        return result
    }
    
    func makeHomeKit() -> Driver<HomeKit?> {
        let triggers = Signal<Void>.merge(
            WorkoutMediator.shared.didLogProgress.map { _ in Void() },
            WorkoutMediator.shared.didSchedule.map { _ in Void() },
            DrillMediator.shared.didLogProgress.map { _ in Void() },
            DrillMediator.shared.didSchedule.map { _ in Void() },
            PlanMediator.shared.didReinit.map { _ in Void() }
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
    
    func makePlanDay() -> Driver<Date> {
        didTapPlanDay
            .startWith(Calendar.current.startOfDay(for: Date()))
            .asDriver(onErrorDriveWith: .never())
    }
}
