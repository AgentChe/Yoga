//
//  GetPaygateRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 27.12.2022.
//

import Alamofire

struct GetPaygateRequest: APIRequestBody {
    let userToken: String

    var url: String {
        GlobalDefinitions.domain + "/api/payments/paygate"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var encoding: ParameterEncoding {
        URLEncoding.default
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken
        ]
    }
}
