//
//  AssignWorkoutRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 08.03.2023.
//

import Alamofire

struct AssignWorkoutRequest: APIRequestBody {
    let userToken: String
    let workoutId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/workouts/assign"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "template_workout_id": workoutId
        ]
    }
}
