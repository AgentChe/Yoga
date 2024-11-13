//
//  GetDrillsResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import Foundation

final class GetDrillsResponse {
    static func map(from response: Any) -> [Drill] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let drillsBundleArray = data["drills"] as? [[String: Any]]
        else {
            return []
        }
        
        return drillsBundleArray.reduce([]) { result, drillBundleJSON -> [Drill] in
            guard
                let categoryId = drillBundleJSON["drill_category_id"] as? Int,
                let drillsArray = drillBundleJSON["drills"] as? [[String: Any]]
            else {
                return result
            }
            
            let drills = drillsArray.compactMap { drillJSON -> Drill? in
                guard
                    let id = drillJSON["drill_id"] as? Int,
                    let name = drillJSON["name"] as? String,
                    let skillLevelId = drillJSON["level_id"] as? Int,
                    let imagePath = drillJSON["image"] as? String,
                    let imageUrl = URL(string: imagePath),
                    let paid = drillJSON["paid"] as? Bool,
                    let instruction = drillJSON["description"] as? String
                else {
                    return nil
                }
                
                return Drill(
                    id: id,
                    name: name,
                    skillLevelId: skillLevelId,
                    image: imageUrl,
                    categoryId: categoryId,
                    paid: paid,
                    instruction: instruction
                )
            }
            
            return result + drills
        }
    }
}
