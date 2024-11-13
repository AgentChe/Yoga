//
//  DrillTrainingInstructionViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 09.02.2023.
//

import RxSwift
import RxCocoa

final class DrillTrainingInstructionViewModel {
    enum Route {
        case training(customerDrillId: Int)
        case calendar(customerDrillId: Int)
    }
    
    enum Source {
        case drill(Drill)
        case planDrill(PlanDrill)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var didTapStartTraining = PublishRelay<Void>()
    lazy var didTapCalendar = PublishRelay<Void>()
    
    lazy var route = makeRoute()
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    lazy var assignActivity = RxActivityIndicator()
    
    private let source: Driver<Source>
    private lazy var drill = makeDrill()
    private lazy var drillCategories = makeDrillCategories()
    private lazy var skillLevels = makeSkillLevels()
    
    private lazy var drillManager = DrillManager()
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(source: Source) {
        self.source = BehaviorRelay(value: source).asDriver()
    }
}

// MARK: Private
private extension DrillTrainingInstructionViewModel {
    func makeRoute() -> Driver<Route> {
        let calendarRoute = didTapCalendar
            .withLatestFrom(drill)
            .flatMapLatest { [weak self] drill -> Driver<Route> in
                guard let self else {  return .never() }
                
                func source() -> Single<Route> {
                    self.drillManager
                        .assignDrill(id: drill.id)
                        .flatMap { assignedDrill -> Single<Route> in
                            guard let assignedDrill = assignedDrill else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(.calendar(customerDrillId: assignedDrill.customerDrillId))
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
                    .trackActivity(self.assignActivity)
                    .asDriver(onErrorDriveWith: .never())
            }
            .asDriver(onErrorDriveWith: .never())
        
        let trainingRoute = didTapStartTraining
            .withLatestFrom(source)
            .flatMapLatest { [weak self] input -> Driver<Route> in
                guard let self = self else {
                    return .never()
                }
                
                switch input {
                case .drill(let drill):
                    func source() -> Single<Route> {
                        self.drillManager
                            .assignDrill(id: drill.id)
                            .flatMap { assignedDrill -> Single<Route> in
                                guard let assignedDrill = assignedDrill else {
                                    return .error(ContentError(.notContent))
                                }
                                
                                return .just(.training(customerDrillId: assignedDrill.customerDrillId))
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
                        .trackActivity(self.assignActivity)
                        .asDriver(onErrorDriveWith: .never())
                case .planDrill(let planDrill):
                    return .just(.training(customerDrillId: planDrill.customerDrillId))
                }
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver.merge(calendarRoute, trainingRoute)
    }
    
    func makeElements() -> Driver<[DTITableElement]> {
        Driver
            .combineLatest(drill, drillCategories, skillLevels)
            .map { drill, drillCategories, skillLevels -> [DTITableElement] in
                var result = [DTITableElement]()
                
                let headerElement = DTIHeaderElement(image: drill.image,
                                                     name: drill.name,
                                                     skillLevel: skillLevels.first(where: { $0.id == drill.skillLevelId })?.name ?? "",
                                                     drillCategory: drillCategories.first(where: { $0.id == drill.categoryId })?.name ?? "")
                result.append(.header(headerElement))
                
                result.append(contentsOf: [
                    .offset(16.scale),
                    .buttons
                ])
                
                result.append(contentsOf: [
                    .offset(24.scale),
                    .instruction(drill.instruction)
                ])
                
                return result
            }
    }
    
    func makeDrill() -> Driver<Drill> {
        source
            .flatMapLatest { [weak self] input -> Driver<Drill> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Drill> {
                    switch input {
                    case .drill(let drill):
                        return .just(drill)
                    case .planDrill(let planDrill):
                        return self.drillManager
                            .obtainDrillTraining(customerDrillId: planDrill.customerDrillId)
                            .flatMap { planDrill -> Single<Drill> in
                                guard let planDrill = planDrill else {
                                    return .error(ContentError(.notContent))
                                }
                                
                                return .just(planDrill.drill)
                            }
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
    
    func makeDrillCategories() -> Driver<[DrillCategory]> {
        drillManager
            .obtainDrillCategories(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeSkillLevels() -> Driver<[SkillLevel]> {
        contentManager
            .obtainLevels(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
}
