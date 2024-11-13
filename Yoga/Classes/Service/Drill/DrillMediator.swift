//
//  DrillMediator.swift
//  Soccer
//
//  Created by Андрей Чернышев on 09.03.2023.
//

import RxSwift
import RxCocoa

final class DrillMediator {
    static let shared = DrillMediator()
    
    private lazy var didLogProgressTrigger = PublishRelay<AssignedDrill>()
    private lazy var didScheduleTrigger = PublishRelay<AssignedDrill>()
    private lazy var didAssignTrigger = PublishRelay<AssignedDrill>()
    
    private init() {}
}

// MARK: Public
extension DrillMediator {
    func didLogProgress(_ assignedDrill: AssignedDrill) {
        DispatchQueue.main.async {
            Self.shared.didLogProgressTrigger.accept(assignedDrill)
        }
    }
    
    func didSchedule(_ assignedDrill: AssignedDrill) {
        DispatchQueue.main.async {
            Self.shared.didScheduleTrigger.accept(assignedDrill)
        }
    }
    
    func didAssign(_ assignedDrill: AssignedDrill) {
        DispatchQueue.main.async {
            Self.shared.didAssignTrigger.accept(assignedDrill)
        }
    }
    
    var didLogProgress: Signal<AssignedDrill> {
        didLogProgressTrigger.asSignal()
    }
    
    var didSchedule: Signal<AssignedDrill> {
        didScheduleTrigger.asSignal()
    }
    
    var didAssign: Signal<AssignedDrill> {
        didAssignTrigger.asSignal()
    }
}
