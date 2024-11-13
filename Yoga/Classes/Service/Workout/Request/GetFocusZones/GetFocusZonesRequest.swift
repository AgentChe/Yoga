//
//  GetFocusZonesRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 01.03.2023.
//

import Alamofire

struct GetFocusZonesRequest: APIRequestBody {
    let userToken: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/glossary/body_parts"
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
