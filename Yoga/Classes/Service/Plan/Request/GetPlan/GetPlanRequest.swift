//
//  GetPlanRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 08.03.2023.
//

import Alamofire

struct GetPlanRequest: APIRequestBody {
    let userToken: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/plan/list"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken
        ]
    }
}
