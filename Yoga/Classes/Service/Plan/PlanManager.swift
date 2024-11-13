//
//  PlanManager.swift
//  Soccer
//
//  Created by Андрей Чернышев on 08.03.2023.
//

import RxSwift

protocol PlanManagerProtocol {
    func obtainPlan() -> Single<[PlanOnDay]>
    func reinitPlan() -> Single<Void>
}

final class PlanManager {
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: PlanManagerProtocol
extension PlanManager: PlanManagerProtocol {
    func obtainPlan() -> Single<[PlanOnDay]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetPlanRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetPlanResponse.map(from: $0) }
    }
    
    func reinitPlan() -> Single<Void> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = ReinitPlanRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
            .do(onSuccess: {
                PlanMediator.shared.didReinitNotify()
            })
    }
}
