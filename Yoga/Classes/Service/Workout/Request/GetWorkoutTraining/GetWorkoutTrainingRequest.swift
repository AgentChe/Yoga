//
//  GetWorkoutTrainingRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 08.03.2023.
//

import Alamofire

struct GetWorkoutTrainingRequest: APIRequestBody {
    let userToken: String
    let customerWorkoutId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/workouts/details"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "customer_workout_id": customerWorkoutId,
        ]
    }
}
