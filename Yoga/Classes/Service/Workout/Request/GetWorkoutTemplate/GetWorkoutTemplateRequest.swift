//
//  GetWorkoutTemplateRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 08.03.2023.
//

import Alamofire

struct GetWorkoutTemplateRequest: APIRequestBody {
    let userToken: String
    let workoutCoverId: Int?
    let focusZoneId: Int?
    let workoutStepId: Int?
    let levelId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/workouts/template"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: [String: Any] = [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "level_id": levelId
        ]
        
        if let workoutCoverId = workoutCoverId {
            params["workout_name_id"] = workoutCoverId
        }
        
        if let focusZoneId = focusZoneId {
            params["body_part_id"] = focusZoneId
        }
        
        if let workoutStepId = workoutStepId {
            params["training_step_id"] = workoutStepId
        }
        
        return params
    }
}
