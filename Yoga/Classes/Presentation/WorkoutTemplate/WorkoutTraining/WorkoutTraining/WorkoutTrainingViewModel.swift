//
//  WorkoutTrainingViewModel.swift
//  Soccer
//
//  Created by Виталий Загороднов on 23.03.2023.
//

import RxSwift
import RxCocoa

final class WorkoutTrainingViewModel {
    enum Route {
        case finished(WorkoutTraining)
    }
    
    enum MenuState {
        case first
        case middle
        case last
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var currentAndNextExercise = makeCurrentAndNextExercise()
    lazy var currentIndex = makeCurrentIndex()
    lazy var exercises = workoutTraining.map { $0.template.exercises }
    lazy var menuState = makeMenuState()
    lazy var route = makeRoute()
    
    lazy var didFinishExersise = PublishRelay<(time: Int, id: Int)>()
    lazy var didFinishWorkout = PublishRelay<(time: Int, id: Int)>()
    lazy var didTapNext = PublishRelay<Void>()
    lazy var didTapPrevios = PublishRelay<Void>()
    
    lazy var activity = RxActivityIndicator()
    
    private lazy var workoutTraining = makeWorkoutTraining()
    private lazy var steps = makeSteps()
    private let customerWorkoutId: Driver<Int>
    
    private lazy var workoutManager = WorkoutManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(customerWorkoutId: Int) {
        self.customerWorkoutId = BehaviorRelay(value: customerWorkoutId).asDriver()
    }
}

// MARK: Private
private extension WorkoutTrainingViewModel {
    func makeWorkoutTraining() -> Driver<WorkoutTraining> {
        customerWorkoutId
            .flatMapLatest { [weak self] customerWorkoutId in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<WorkoutTraining> {
                    self.workoutManager
                        .obtainWorkoutTraining(customerWorkoutId: customerWorkoutId)
                        .map { workoutTrainig  in
                            guard let workoutTrainig else {
                                throw ContentError(.notContent)
                            }
                            
                            return workoutTrainig
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(
                        source: source,
                        trigger: trigger
                    )
                    .trackActivity(self.activity)
                    .asDriver(onErrorDriveWith: .never())
            }
    }
    
    func saveProgress(customerWorkoutId: Int, exerciseId: Int, trainedTime: Int, finish: Bool) -> Observable<AssignedWorkout?> {
        func source() -> Single<AssignedWorkout?> { 
            workoutManager.logProgress(
                customerWorkoutId: customerWorkoutId,
                exerciseId: exerciseId,
                trainedTime: trainedTime,
                finish: finish
            )
        }
        
        func trigger(error: Error) -> Observable<Void> {
            guard let tryAgain = self.tryAgain?(error) else {
                return .empty()
            }
            
            return tryAgain
        }
        
        return observableRetrySingle
            .retry(
                source: source,
                trigger: trigger
            )
            .asObservable()
    }
    
    func makeRoute() -> Signal<Route> {
        let customerWorkoutId = workoutTraining
            .map(\.assignedWorkout.customerWorkoutId)
            .asObservable()
        
        let finishWorkout = didFinishWorkout
            .withLatestFrom(customerWorkoutId) { ($0, $1) }
            .flatMapLatest { [weak self] args -> Observable<Route?> in
                guard let self = self else {
                    return .never()
                }
                
                let ((time, exerciseId), customerWorkoutId) = args
                
                return self.saveProgress(
                    customerWorkoutId: customerWorkoutId,
                    exerciseId: exerciseId,
                    trainedTime: time,
                    finish: true
                )
                .withLatestFrom(self.workoutTraining) { ($0, $1) }
                .map { assignedWorkout, workoutTraining in
                    guard let assignedWorkout else { return nil }
                    
                    let training = WorkoutTraining(template: workoutTraining.template, assignedWorkout: assignedWorkout)
                    return .finished(training)
                }
                .trackActivity(self.activity)
            }
        
        let finishExersise = didFinishExersise
            .withLatestFrom(customerWorkoutId) { ($0, $1) }
            .flatMapLatest { [weak self] args -> Observable<Route?> in
                guard let self = self else {
                    return .never()
                }
                
                let ((time, exerciseId), customerWorkoutId) = args
                
                return self.saveProgress(
                    customerWorkoutId: customerWorkoutId,
                    exerciseId: exerciseId,
                    trainedTime: time,
                    finish: false
                )
                .map { _ in nil }
            }
        
        return Observable
            .merge(finishWorkout, finishExersise)
            .compactMap { $0 }
            .asSignal(onErrorSignalWith: .never())
    }
    
    func makeSteps() -> Driver<[WorkoutStep]> {
        workoutManager
            .obtainWorkoutSteps(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeCurrentAndNextExercise() -> Driver<(current: WorkoutExercise, next: WorkoutExercise?)> {
        currentIndex
            .withLatestFrom(exercises) { ($0, $1) }
            .compactMap { currentIndex, exercises in
                guard let current = exercises[safe: currentIndex] else { return nil }
                return (current, exercises[safe: currentIndex + 1])
            }
    }
    
    func makeCurrentIndex() -> Driver<Int> {
        enum Action {
            case next
            case previos
            case set([WorkoutExercise])
        }
        
        let initial: (elements: [WorkoutExercise], index: Int?) = ([], nil)
        
        return Observable<Action>
            .merge(
                didTapNext.map { .next },
                didTapPrevios.map { .previos },
                workoutTraining.asObservable().map { .set($0.template.exercises) }
            )
            .scan(into: initial) { result, action in
                switch action {
                case .next:
                    guard let currentIndex = result.index else {
                        return
                    }
                    
                    result.index = result.elements.indices.contains(currentIndex + 1)
                        ? currentIndex + 1
                        : currentIndex
                case .previos:
                    guard let currentIndex = result.index else {
                        return
                    }
                    
                    result.index = result.elements.indices.contains(currentIndex - 1)
                        ? currentIndex - 1
                        : currentIndex
                case let .set(elements):
                    guard elements.count > 0 else {
                        return
                    }
                    result.elements = elements
                    result.index = 0
                }
            }
            .compactMap { $0.index }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeMenuState() -> Driver<MenuState> {
       Driver
            .combineLatest(currentIndex, exercises)
            .compactMap { currentIndex, elements -> MenuState? in
                guard currentIndex > 0 else {
                    return .first
                }
                
                guard currentIndex < elements.count - 1 else {
                    return .last
                }
                
                return .middle
            }
    }
}
