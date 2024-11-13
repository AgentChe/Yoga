//
//  GetDrillCategoriesResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.02.2023.
//

final class GetDrillCategoriesResponse {
    static func map(from response: Any) -> [DrillCategory] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let drillCategoriesArray = data["drill_categories"] as? [[String: Any]]
        else {
            return []
        }
        
        return drillCategoriesArray.compactMap { drillCategoryJSON -> DrillCategory? in
            guard
                let id = drillCategoryJSON["drill_category_id"] as? Int,
                let name = drillCategoryJSON["name"] as? String
            else {
                return nil
            }
            
            return DrillCategory(id: id,
                                 name: name)
        }
    }
}
