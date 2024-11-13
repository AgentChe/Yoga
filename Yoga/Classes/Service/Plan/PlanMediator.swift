//
//  PlanMediator.swift
//  Soccer
//
//  Created by Андрей Чернышев on 09.03.2023.
//

import RxSwift
import RxCocoa

final class PlanMediator {
    static let shared = PlanMediator()
    
    private lazy var didReinitTrigger = PublishRelay<Void>()
    
    private init() {}
}

// MARK: Public
extension PlanMediator {
    func didReinitNotify() {
        DispatchQueue.main.async {
            Self.shared.didReinitTrigger.accept(Void())
        }
    }
    
    var didReinit: Signal<Void> {
        didReinitTrigger.asSignal()
    }
}
