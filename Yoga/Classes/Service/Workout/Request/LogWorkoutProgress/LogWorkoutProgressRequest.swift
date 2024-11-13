//
//  LogWorkoutProgressRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 08.03.2023.
//

import Alamofire

struct LogWorkoutProgressRequest: APIRequestBody {
    let userToken: String
    let customerWorkoutId: Int
    let exerciseId: Int
    let trainedTime: Int
    let finish: Bool
    
    var url: String {
        GlobalDefinitions.domain + "/api/workouts/progress"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "customer_workout_id": customerWorkoutId,
            "exercise_id": exerciseId,
            "trained_time": trainedTime,
            "finish_workout": finish
        ]
    }
}
