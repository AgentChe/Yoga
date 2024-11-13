//
//  CalendarViewModel.swift
//  Soccer
//
//  Created by Виталий Загороднов on 21.04.2023.
//

import RxSwift
import RxCocoa

final class CalendarViewModel {
    enum SchedulerType {
        case drill(customerDrillId: Int)
        case workout(customerWorkoutId: Int)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    lazy var didTapAdd = PublishRelay<Void>()
    lazy var selectedDate = BehaviorRelay<Date?>(value: nil)
    
    lazy var activity = RxActivityIndicator()
    lazy var plan = makePlan()
    lazy var scheduleResult = makeAddScheduleResult()
    
    private let schedulerType: SchedulerType
    
    init(schedulerType: SchedulerType) {
        self.schedulerType = schedulerType
    }
    
    private lazy var planManager = PlanManager()
    private lazy var drillManager = DrillManager()
    private lazy var workoutManager = WorkoutManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension CalendarViewModel {
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
    
    func makeAddScheduleResult() -> Signal<Void> {
        didTapAdd
            .withLatestFrom(selectedDate.compactMap { $0 })
            .flatMapLatest { [weak self] date -> Observable<Void> in
                guard let self else { return .never() }
                
                func source() -> Single<Void> {
                    switch self.schedulerType {
                    case let .drill(customerDrillId):
                        return self.drillManager.scheduleDrill(customerDrillId: customerDrillId, scheduleDate: date.timeIntervalSince1970)
                            .mapToVoid()
                    case let .workout(customerWorkoutId):
                        return self.workoutManager.scheduleWorkout(id: customerWorkoutId, scheduleDate: date.timeIntervalSince1970)
                            .mapToVoid()
                    }
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
            }
            .asSignal(onErrorSignalWith: .never())
    }
}
