//
//  DrillTrainingViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import RxSwift
import RxCocoa

final class DrillTrainingViewModel {
    enum Route {
        case finished(DrillTraining)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var didFinishTraining = PublishRelay<Int>()
    
    lazy var activity = RxActivityIndicator()
    lazy var route = makeRoute()
    lazy var startTraining = makeStartTraining()
    lazy var drill = makeDrill()
    
    private lazy var drillTraining = makeDrillTraining()
    private let customerDrillId: Driver<Int>
    
    private lazy var drillManager = DrillManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(customerDrillId: Int) {
        self.customerDrillId = BehaviorRelay(value: customerDrillId).asDriver()
    }
}

// MARK: Private
private extension DrillTrainingViewModel {
    func makeRoute() -> Driver<Route> {
        didFinishTraining
            .withLatestFrom(drillTraining) { ($0, $1) }
            .flatMapLatest { [weak self] totalSeconds, drillTraining -> Observable<DrillTraining> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<DrillTraining> {
                    self.drillManager
                        .logProgress(
                            customerDrillId: drillTraining.assignedDrill.customerDrillId,
                            trainedTime: totalSeconds,
                            finish: true
                        )
                        .flatMap { assignedDrill -> Single<DrillTraining> in
                            guard let assignedDrill = assignedDrill else {
                                return .error(ContentError(.notContent))
                            }
                            
                            let result = DrillTraining(
                                drill: drillTraining.drill,
                                assignedDrill: assignedDrill
                            )
                            return .just(result)
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
            }
            .map { Route.finished($0) }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeStartTraining() -> Signal<Void> {
        drillTraining
            .map { _ in Void() }
            .asSignal(onErrorSignalWith: .never())
    }
    
    func makeDrill() -> Driver<Drill> {
        drillTraining
            .map { $0.drill }
    }
    
    func makeDrillTraining() -> Driver<DrillTraining> {
        customerDrillId
            .flatMapLatest { [weak self] customerDrillId -> Driver<DrillTraining> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<DrillTraining> {
                    self.drillManager
                        .obtainDrillTraining(customerDrillId: customerDrillId)
                        .flatMap { drillTraining -> Single<DrillTraining> in
                            guard let drillTraining = drillTraining else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(drillTraining)
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
}
