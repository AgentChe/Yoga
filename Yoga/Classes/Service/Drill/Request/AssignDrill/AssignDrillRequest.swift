//
//  AssignDrillRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Alamofire

struct AssignDrillRequest: APIRequestBody {
    let userToken: String
    let drillId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/drills/assign"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "drill_id": drillId
        ]
    }
}
