//
//  LogDrillProgressRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Alamofire

struct LogDrillProgressRequest: APIRequestBody {
    let userToken: String
    let customerDrillId: Int
    let trainedTime: Int
    let finish: Bool
    
    var url: String {
        GlobalDefinitions.domain + "/api/drills/progress"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "customer_drill_id": customerDrillId,
            "trained_time": trainedTime,
            "finish": finish
        ]
    }
}
