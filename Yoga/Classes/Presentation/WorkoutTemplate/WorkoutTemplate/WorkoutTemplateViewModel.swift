//
//  WorkoutTemplateViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import RxSwift
import RxCocoa

final class WorkoutTemplateViewModel {
    enum Route {
        case training(customerWorkoutId: Int)
        case calendar(customerWorkoutId: Int)
    }
    enum Source {
        case cover(WorkoutCover)
        case focusZone(FocusZone)
        case step(WorkoutStep)
        case template(WorkoutTemplate)
        case plan(PlanWorkout)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var didTapStartTraining = PublishRelay<Void>()
    lazy var didTapCalendar = PublishRelay<Void>()
    
    lazy var route = makeRoute()
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    lazy var assignActivity = RxActivityIndicator()
    
    private lazy var template = makeTemplate()
    private lazy var focusZones = makeFocusZones()
    private lazy var steps = makeSteps()
    private lazy var skillLevels = makeSkillLevels()
    private let source: Driver<Source>
    private lazy var skillLevelId = makeSkillLevelId()
    
    private lazy var workoutManager = WorkoutManager()
    private lazy var profileManager = ProfileManager()
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(source: Source) {
        self.source = BehaviorRelay(value: source).asDriver()
    }
}

// MARK: Private
private extension WorkoutTemplateViewModel {
    func makeRoute() -> Driver<Route> {
        enum Action {
            case training
            case calendar
        }
        
        return Observable<Action>
            .merge(
                didTapCalendar.map { _ in .calendar },
                didTapStartTraining.map { _ in .training }
            )
            .withLatestFrom(template) { ($0, $1) }
            .withUnretained(self)
            .flatMapLatest { base, args -> Driver<Route> in
                let (action, template) = args
                
                func source() -> Single<Route> {
                    base.workoutManager.assignWorkout(id: template.id)
                        .map { assignedWorkout -> Route in
                            guard let assignedWorkout else {
                                throw ContentError(.notContent)
                            }
                            
                            switch action {
                            case .training:
                                return .training(customerWorkoutId: assignedWorkout.customerWorkoutId)
                            case .calendar:
                                return .calendar(customerWorkoutId: assignedWorkout.customerWorkoutId)
                            }
                            
                            
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = base.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return base.observableRetrySingle
                    .retry(
                        source: source,
                        trigger: trigger
                    )
                    .trackActivity(base.assignActivity)
                    .asDriver(onErrorDriveWith: .never())
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeElements() -> Driver<[WorkoutTemplateTableElement]> {
        Driver
            .combineLatest(
                template,
                focusZones,
                steps,
                skillLevels
            )
            .map { template, focusZones, steps, skillLevels -> [WorkoutTemplateTableElement] in
                var result = [WorkoutTemplateTableElement]()
                
                let headerElement = WorkoutTemplateHeaderElement(
                    image: template.image,
                    name: template.name,
                    skillLevel: skillLevels.first(where: { $0.id == template.levelId })?.name ?? "",
                    exerciseCount: template.exercises.count
                )
                result.append(.header(headerElement))
                
                result.append(contentsOf: [
                    .offset(16.scale),
                    .buttons
                ])
                
                if let focusZonesIds = template.focusZonesIds, !focusZones.isEmpty {
                    let focusZonesElement = focusZones.filter { focusZone -> Bool in
                        focusZonesIds.contains(where: { $0 == focusZone.id })
                    }
                    result.append(contentsOf: [
                        .offset(32.scale),
                        .focusZones(focusZonesElement)
                    ])
                }
                
                template.exercises.forEach { exercise in
                    result.append(contentsOf: [
                        .offset(16.scale),
                        .exercise(exercise)
                    ])
                }
                
                return result
            }
    }
    
    func makeTemplate() -> Driver<WorkoutTemplate> {
        Driver
            .combineLatest(source, skillLevelId)
            .flatMapLatest { [weak self] input, skillLevelId -> Driver<WorkoutTemplate> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<WorkoutTemplate> {
                    let result: Single<WorkoutTemplate?>
                    
                    switch input {
                    case .cover(let cover):
                        result = self.workoutManager
                            .obtainWorkoutTemplate(
                                coverId: cover.id,
                                levelId: skillLevelId
                            )
                    case .focusZone(let focusZone):
                        result = self.workoutManager
                            .obtainWorkoutTemplate(
                                focusZoneId: focusZone.id,
                                levelId: skillLevelId
                            )
                    case .step(let step):
                        result = self.workoutManager
                            .obtainWorkoutTemplate(
                                stepId: step.id,
                                levelId: skillLevelId
                            )
                    case .template(let template):
                        result = .just(template)
                    case .plan(let plan):
                        result = self.workoutManager
                            .obtainWorkoutTraining(customerWorkoutId: plan.customerWorkoutId)
                            .map { $0?.template }
                    }
                    
                    return result
                        .flatMap { template -> Single<WorkoutTemplate> in
                            guard let template = template else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(template)
                        }
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
                    .asDriver(onErrorDriveWith: .never())
            }
    }
    
    func makeSkillLevelId() -> Driver<Int> {
        profileManager
            .obtainProfile(forceUpdate: false)
            .compactMap { $0?.skillLevelId }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeFocusZones() -> Driver<[FocusZone]> {
        workoutManager
            .obtainFocusZones(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeSteps() -> Driver<[WorkoutStep]> {
        workoutManager
            .obtainWorkoutSteps(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeSkillLevels() -> Driver<[SkillLevel]> {
        contentManager
            .obtainLevels(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
}
