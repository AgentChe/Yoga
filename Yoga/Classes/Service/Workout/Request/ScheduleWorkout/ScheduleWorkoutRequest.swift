//
//  ScheduleWorkoutRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 08.03.2023.
//

import Alamofire

struct ScheduleWorkoutRequest: APIRequestBody {
    let userToken: String
    let customerWorkoutId: Int
    let scheduleDate: TimeInterval
    
    var url: String {
        GlobalDefinitions.domain + "/api/workouts/schedule"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "template_workout_id": customerWorkoutId,
            "schedule_date": scheduleDate
        ]
    }
}
