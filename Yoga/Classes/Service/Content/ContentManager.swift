//
//  ContentManager.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.02.2023.
//

import RxSwift

protocol ContentManagerProtocol {
    func obtainHomeKit() -> Single<HomeKit?>
    func obtainLevels(forceUpdate: Bool) -> Single<[SkillLevel]>
}

final class ContentManager {
    enum Constants {
        static let skillLevels = "content_manager_skill_levels_key"
    }
    
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: ContentManagerProtocol
extension ContentManager: ContentManagerProtocol {
    func obtainHomeKit() -> Single<HomeKit?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }

        let request = GetHomeKitRequest(userToken: userToken)

        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetHomeKitResponse.map(from: $0) }
    }
    
    func obtainLevels(forceUpdate: Bool) -> Single<[SkillLevel]> {
        forceUpdate ? loadLevels() : cachedLevels()
    }
}

// MARK: Private
private extension ContentManager {
    func loadLevels() -> Single<[SkillLevel]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetSkillLevelsRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetSkillLevelsResponse.map(from: $0) }
            .do(onSuccess: { levels in
                guard let data = try? JSONEncoder().encode(levels) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.skillLevels)
            })
    }
    
    func cachedLevels() -> Single<[SkillLevel]> {
        Single<[SkillLevel]>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.skillLevels) else {
                event(.success([]))
                return Disposables.create()
            }
            
            let levels = try? JSONDecoder().decode([SkillLevel].self, from: data)
            
            event(.success(levels ?? []))
            
            return Disposables.create()
        }
    }
}
