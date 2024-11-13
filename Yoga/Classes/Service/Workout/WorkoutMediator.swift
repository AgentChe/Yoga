//
//  WorkoutMediator.swift
//  Soccer
//
//  Created by Андрей Чернышев on 09.03.2023.
//

import RxSwift
import RxCocoa

final class WorkoutMediator {
    static let shared = WorkoutMediator()
    
    private lazy var didLogProgressTrigger = PublishRelay<AssignedWorkout>()
    private lazy var didScheduleTrigger = PublishRelay<AssignedWorkout>()
    private lazy var didAssignTrigger = PublishRelay<AssignedWorkout>()
    
    private init() {}
}

// MARK: Public
extension WorkoutMediator {
    func didLogProgress(_ asssignedWorkout: AssignedWorkout) {
        DispatchQueue.main.async {
            Self.shared.didLogProgressTrigger.accept(asssignedWorkout)
        }
    }
    
    func didSchedule(_ asssignedWorkout: AssignedWorkout) {
        DispatchQueue.main.async {
            Self.shared.didScheduleTrigger.accept(asssignedWorkout)
        }
    }
    
    func didAssign(_ asssignedWorkout: AssignedWorkout) {
        DispatchQueue.main.async {
            Self.shared.didAssignTrigger.accept(asssignedWorkout)
        }
    }
    
    var didLogProgress: Signal<AssignedWorkout> {
        didLogProgressTrigger.asSignal()
    }
    
    var didSchedule: Signal<AssignedWorkout> {
        didScheduleTrigger.asSignal()
    }
    
    var didAssign: Signal<AssignedWorkout> {
        didAssignTrigger.asSignal()
    }
}
