//
//  WorkoutManager.swift
//  Soccer
//
//  Created by Андрей Чернышев on 01.03.2023.
//

import RxSwift

protocol WorkoutManagerProtocol {
    func obtainFocusZones(forceUpdate: Bool) -> Single<[FocusZone]>
    func obtainWorkoutSteps(forceUpdate: Bool) -> Single<[WorkoutStep]>
    func obtainWorkoutCovers(forceUpdate: Bool) -> Single<[WorkoutCover]>
    func obtainWorkoutTemplate(coverId: Int, levelId: Int) -> Single<WorkoutTemplate?>
    func obtainWorkoutTemplate(focusZoneId: Int, levelId: Int) -> Single<WorkoutTemplate?>
    func obtainWorkoutTemplate(stepId: Int, levelId: Int) -> Single<WorkoutTemplate?>
    func assignWorkout(id: Int) -> Single<AssignedWorkout?>
    func scheduleWorkout(id: Int, scheduleDate: TimeInterval) -> Single<AssignedWorkout?>
    func obtainWorkoutTraining(customerWorkoutId: Int) -> Single<WorkoutTraining?>
    func logProgress(customerWorkoutId: Int, exerciseId: Int, trainedTime: Int, finish: Bool) -> Single<AssignedWorkout?>
}

final class WorkoutManager {
    enum Constants {
        static let focusZones = "workout_manager_focus_zones_key"
        static let workoutSteps = "workout_manager_workout_steps_key"
        static let workoutCovers = "workout_manager_workout_covers_key"
    }
    
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: WorkoutManagerProtocol
extension WorkoutManager: WorkoutManagerProtocol {
    func obtainFocusZones(forceUpdate: Bool) -> Single<[FocusZone]> {
        forceUpdate ? loadFocusZones() : cachedFocusZones()
    }
    
    func obtainWorkoutSteps(forceUpdate: Bool) -> Single<[WorkoutStep]> {
        forceUpdate ? loadWorkoutSteps() : cachedWorkoutSteps()
    }
    
    func obtainWorkoutCovers(forceUpdate: Bool) -> Single<[WorkoutCover]> {
        forceUpdate ? loadWorkoutCovers() : cachedWorkoutCovers()
    }
    
    func obtainWorkoutTemplate(coverId: Int, levelId: Int) -> Single<WorkoutTemplate?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetWorkoutTemplateRequest(
            userToken: userToken,
            workoutCoverId: coverId,
            focusZoneId: nil,
            workoutStepId: nil,
            levelId: levelId
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetWorkoutTemplateResponse.map(from: $0) }
    }
    
    func obtainWorkoutTemplate(focusZoneId: Int, levelId: Int) -> Single<WorkoutTemplate?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetWorkoutTemplateRequest(
            userToken: userToken,
            workoutCoverId: nil,
            focusZoneId: focusZoneId,
            workoutStepId: nil,
            levelId: levelId
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetWorkoutTemplateResponse.map(from: $0) }
    }
    
    func obtainWorkoutTemplate(stepId: Int, levelId: Int) -> Single<WorkoutTemplate?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetWorkoutTemplateRequest(
            userToken: userToken,
            workoutCoverId: nil,
            focusZoneId: nil,
            workoutStepId: stepId,
            levelId: levelId
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetWorkoutTemplateResponse.map(from: $0) }
    }
    
    func assignWorkout(id: Int) -> Single<AssignedWorkout?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = AssignWorkoutRequest(
            userToken: userToken,
            workoutId: id
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { AssignWorkoutResponse.map(from: $0) }
            .do(onSuccess: { assignedWorkout in
                guard let assignedWorkout = assignedWorkout else {
                    return
                }
                
                WorkoutMediator.shared.didAssign(assignedWorkout)
            })
    }
    
    func scheduleWorkout(id: Int, scheduleDate: TimeInterval) -> Single<AssignedWorkout?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = ScheduleWorkoutRequest(
            userToken: userToken,
            customerWorkoutId: id,
            scheduleDate: scheduleDate
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map {  ScheduleWorkoutResponse.map(from: $0)}
            .do(onSuccess: { assignedWorkout in
                guard let assignedWorkout = assignedWorkout else {
                    return
                }
                
                WorkoutMediator.shared.didSchedule(assignedWorkout)
            })
    }
    
    func obtainWorkoutTraining(customerWorkoutId: Int) -> Single<WorkoutTraining?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetWorkoutTrainingRequest(
            userToken: userToken,
            customerWorkoutId: customerWorkoutId
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetWorkoutTrainingResponse.map(from: $0) }
    }
    
    func logProgress(customerWorkoutId: Int, exerciseId: Int, trainedTime: Int, finish: Bool) -> Single<AssignedWorkout?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = LogWorkoutProgressRequest(
            userToken: userToken,
            customerWorkoutId: customerWorkoutId,
            exerciseId: exerciseId,
            trainedTime: trainedTime,
            finish: finish
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { LogWorkoutProgressResponse.map(from: $0) }
            .do(onSuccess: { assignedWorkout in
                guard let assignedWorkout = assignedWorkout else {
                    return
                }
                
                WorkoutMediator.shared.didLogProgress(assignedWorkout)
            })
    }
}

// MARK: Private
private extension WorkoutManager {
    func loadFocusZones() -> Single<[FocusZone]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetFocusZonesRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetFocusZonesResponse.map(from: $0) }
            .do(onSuccess: { focusZones in
                guard let data = try? JSONEncoder().encode(focusZones) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.focusZones)
            })
    }
    
    func cachedFocusZones() -> Single<[FocusZone]> {
        Single<[FocusZone]>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.focusZones) else {
                event(.success([]))
                return Disposables.create()
            }
            
            let focusZones = try? JSONDecoder().decode([FocusZone].self, from: data)
            
            event(.success(focusZones ?? []))
            
            return Disposables.create()
        }
    }
    
    func loadWorkoutSteps() -> Single<[WorkoutStep]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetWorkoutStepsRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetWorkoutStepsResponse.map(from: $0) }
            .do(onSuccess: { workoutSteps in
                guard let data = try? JSONEncoder().encode(workoutSteps) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.workoutSteps)
            })
    }
    
    func cachedWorkoutSteps() -> Single<[WorkoutStep]> {
        Single<[WorkoutStep]>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.workoutSteps) else {
                event(.success([]))
                return Disposables.create()
            }
            
            let workoutSteps = try? JSONDecoder().decode([WorkoutStep].self, from: data)
            
            event(.success(workoutSteps ?? []))
            
            return Disposables.create()
        }
    }
    
    func loadWorkoutCovers() -> Single<[WorkoutCover]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetWorkoutCoversRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetWorkoutCoversResponse.map(from: $0) }
            .do(onSuccess: { workoutCovers in
                guard let data = try? JSONEncoder().encode(workoutCovers) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.workoutCovers)
            })
    }
    
    func cachedWorkoutCovers() -> Single<[WorkoutCover]> {
        Single<[WorkoutCover]>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.workoutCovers) else {
                event(.success([]))
                return Disposables.create()
            }
            
            let workoutCovers = try? JSONDecoder().decode([WorkoutCover].self, from: data)
            
            event(.success(workoutCovers ?? []))
            
            return Disposables.create()
        }
    }
}
