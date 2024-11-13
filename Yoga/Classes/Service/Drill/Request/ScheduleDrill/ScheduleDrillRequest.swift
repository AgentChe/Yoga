//
//  ScheduleDrillRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Alamofire

struct ScheduleDrillRequest: APIRequestBody {
    let userToken: String
    let customerDrillId: Int
    let scheduleDate: TimeInterval
    
    var url: String {
        GlobalDefinitions.domain + "/api/drills/schedule"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "customer_drill_id": customerDrillId,
            "schedule_date": scheduleDate
        ]
    }
}
