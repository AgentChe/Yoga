//
//  PaygateManager.swift
//  Soccer
//
//  Created by Андрей Чернышев on 27.12.2022.
//

import RxSwift

protocol PaygateManagerProtocol: AnyObject {
    func obtainPaygate(forceUpdate: Bool) -> Single<Paygate?>
}

final class PaygateManager: PaygateManagerProtocol {
    enum Constants {
        static let paygateKey = "paygate_manager_paygate_key"
    }
    
    private lazy var sessionManager = SessionManager()
    
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
}

// MARK: Public
extension PaygateManager {
    func obtainPaygate(forceUpdate: Bool) -> Single<Paygate?> {
        forceUpdate ? loadPaygate() : cachedPaygate()
    }
}

// MARK: Private
private extension PaygateManager {
    func loadPaygate() -> Single<Paygate?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetPaygateRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { try GetPaygateResponse.map(from: $0) }
            .do(onSuccess: { paygate in
                guard let data = try? JSONEncoder().encode(paygate) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.paygateKey)
            })
    }
    
    func cachedPaygate() -> Single<Paygate?> {
        Single<Paygate?>
            .create { event in
                guard
                    let data = UserDefaults.standard.data(forKey: Constants.paygateKey),
                    let paygate = try? JSONDecoder().decode(Paygate.self, from: data)
                else {
                    event(.failure(ContentError(.notContent)))
                    return Disposables.create()
                }
                
                event(.success(paygate))
                
                return Disposables.create()
            }
    }
}
