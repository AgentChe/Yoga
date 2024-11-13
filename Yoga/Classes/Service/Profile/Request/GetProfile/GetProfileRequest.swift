//
//  GetProfileRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 03.02.2023.
//

import Alamofire

struct GetProfileRequest: APIRequestBody {
    let userToken: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/users/show"
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
