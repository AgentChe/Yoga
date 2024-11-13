//
//  SyncTokensRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import Alamofire

struct SyncTokensRequest: APIRequestBody {
    let oldToken: String
    let newToken: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/users/set"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "user_token": newToken,
            "_user_token": oldToken
        ]
    }
}
