//
//  SetRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 28.08.2022.
//

import Alamofire

struct SetRequest: APIRequestBody {
    let userToken: String
    let skillLevel: Int?
    let weekSchedule: [Int]?
    let drills: [Int]?
    let focusZones: [Int]?
    let timezone: String?
    let gender: Int?
    
    var url: String {
        GlobalDefinitions.domain + "/api/users/set"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: [String: Any] = [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken
        ]
        
        if let skillLevel = skillLevel {
            params["level_id"] = skillLevel
        }
        
        if let weekSchedule = weekSchedule {
            params["training_days"] = weekSchedule
        }
        
        if let drills = drills {
            params["drill_category_ids"] = drills
        }
        
        if let focusZones = focusZones {
            params["body_part_ids"] = focusZones
        }
        
        if let timezone = timezone {
            params["timezone"] = timezone
        }
        
        if let gender = gender {
            params["gender"] = gender
        }
        
        return params
    }
}
