//
//  DefaultRequestWrapper.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.03.2022.
//

import RxSwift
import Alamofire

final class DefaultRequestWrapper {
    func callServerApi(requestBody: APIRequestBody) -> Single<Any> {
        execute(request: requestBody)
    }
}

// MARK: Private
private extension DefaultRequestWrapper {
    func execute(request: APIRequestBody, attempt: Int = 1, maxCount: Int = 3) -> Single<Any> {
        RestAPITransport()
            .callServerApi(requestBody: request)
            .catch { [weak self] error -> Single<Any> in
                guard let self = self else {
                    return .never()
                }
                
                let isLastAttempt = attempt == maxCount
                
                return isLastAttempt ? .error(error) : self.execute(request: request, attempt: attempt + 1)
            }
            .flatMap { [weak self] response -> Single<Any> in
                guard let self = self else {
                    return .never()
                }
                
                guard let error = self.error(response: response) else {
                    return .just(response)
                }
                
                let isLastAttempt = attempt == maxCount
                
                return isLastAttempt ? .error(error) : self.execute(request: request, attempt: attempt + 1)
            }
    }
    
    func error(response: Any) -> Error? {
        guard
            let json = response as? [String: Any],
            let code = json["_code"] as? Int
        else {
            return NetworkError(.serverNotAvailable)
        }
        
        if code == 200 {
            return nil
        }
        
        if let errorMessage = json["_msg"] as? String {
            return NetworkError(.logical(errorMessage))
        }
        
        return NetworkError(.serverNotAvailable)
    }
}
