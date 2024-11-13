//
//  DrillManager.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.03.2023.
//

import RxSwift

protocol DrillManagerProtocol {
    func obtainDrillCategories(forceUpdate: Bool) -> Single<[DrillCategory]>
    func obtainDrills(categoryId: Int?, levelId: Int?) -> Single<[Drill]>
    func assignDrill(id: Int) -> Single<AssignedDrill?>
    func scheduleDrill(customerDrillId: Int, scheduleDate: TimeInterval) -> Single<AssignedDrill?>
    func obtainDrillTraining(customerDrillId: Int) -> Single<DrillTraining?>
    func logProgress(customerDrillId: Int, trainedTime: Int, finish: Bool) -> Single<AssignedDrill?>
}

final class DrillManager {
    enum Constants {
        static let drillCategoriesKey = "content_manager_drill_categories_key"
    }
    
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: DrillManagerProtocol
extension DrillManager: DrillManagerProtocol {
    func obtainDrillCategories(forceUpdate: Bool) -> Single<[DrillCategory]> {
        forceUpdate ? loadDrillCategories() : cachedDrillCategories()
    }
    
    func obtainDrills(categoryId: Int?, levelId: Int?) -> Single<[Drill]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }

        let request = GetDrillsRequest(
            userToken: userToken,
            categoryId: categoryId,
            levelId: levelId
        )

        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetDrillsResponse.map(from: $0) }
    }
    
    func assignDrill(id: Int) -> Single<AssignedDrill?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = AssignDrillRequest(
            userToken: userToken,
            drillId: id
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { AssignDrillResponse.map(from: $0) }
            .do(onSuccess: { assignDrill in
                guard let assignDrill = assignDrill else {
                    return
                }
                
                DrillMediator.shared.didAssign(assignDrill)
            })
    }
    
    func scheduleDrill(customerDrillId: Int, scheduleDate: TimeInterval) -> Single<AssignedDrill?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = ScheduleDrillRequest(
            userToken: userToken,
            customerDrillId: customerDrillId,
            scheduleDate: scheduleDate
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { ScheduleDrillResponse.map(from: $0) }
            .do(onSuccess: { assignDrill in
                guard let assignDrill = assignDrill else {
                    return
                }
                
                DrillMediator.shared.didSchedule(assignDrill)
            })
    }
    
    func obtainDrillTraining(customerDrillId: Int) -> Single<DrillTraining?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetDrillTrainingRequest(
            userToken: userToken,
            customerDrillId: customerDrillId
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetDrillTrainingResponse.map(from: $0) }
    }
    
    func logProgress(customerDrillId: Int, trainedTime: Int, finish: Bool) -> Single<AssignedDrill?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = LogDrillProgressRequest(
            userToken: userToken,
            customerDrillId: customerDrillId,
            trainedTime: trainedTime,
            finish: finish
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { LogDrillProgressResponse.map(from: $0) }
            .do(onSuccess: { assignDrill in
                guard let assignDrill = assignDrill else {
                    return
                }
                
                DrillMediator.shared.didLogProgress(assignDrill)
            })
    }
}

// MARK: Private
private extension DrillManager {
    func loadDrillCategories() -> Single<[DrillCategory]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetDrillCategoriesRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetDrillCategoriesResponse.map(from: $0) }
            .do(onSuccess: { drills in
                guard let data = try? JSONEncoder().encode(drills) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.drillCategoriesKey)
            })
    }
    
    func cachedDrillCategories() -> Single<[DrillCategory]> {
        Single<[DrillCategory]>
            .create { event in
                guard let data = UserDefaults.standard.data(forKey: Constants.drillCategoriesKey) else {
                    event(.success([]))
                    return Disposables.create()
                }
                
                let drillCategories = try? JSONDecoder().decode([DrillCategory].self, from: data)
                
                event(.success(drillCategories ?? []))
                
                return Disposables.create()
            }
    }
}
