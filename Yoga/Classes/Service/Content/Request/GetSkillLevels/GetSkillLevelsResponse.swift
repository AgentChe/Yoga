//
//  GetSkillLevelsResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 01.03.2023.
//

final class GetSkillLevelsResponse {
    static func map(from response: Any) -> [SkillLevel] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let levelsArray = data["levels"] as? [[String: Any]]
        else {
            return []
        }
        
        return levelsArray.compactMap { levelJSON -> SkillLevel? in
            guard
                let id = levelJSON["level_id"] as? Int,
                let name = levelJSON["name"] as? String
            else {
                return nil
            }
            
            return SkillLevel(
                id: id,
                name: name
            )
        }
    }
}
