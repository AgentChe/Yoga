//
//  GetWorkoutCoversResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Foundation

final class GetWorkoutCoversResponse {
    static func map(from response: Any) -> [WorkoutCover] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let coversArray = data["workout_names"] as? [[String: Any]]
        else {
            return []
        }
        
        return coversArray.compactMap { coverJSON -> WorkoutCover? in
            guard
                let id = coverJSON["workout_name_id"] as? Int,
                let name = coverJSON["name"] as? String,
                let imagePath = coverJSON["image"] as? String,
                let imageUrl = URL(string: imagePath),
                let paid = coverJSON["paid"] as? Bool,
                let exercisesCount = coverJSON["exercises_count"] as? Int
            else {
                return nil
            }
            
            return WorkoutCover(
                id: id,
                name: name,
                image: imageUrl,
                paid: paid,
                exercisesCount: exercisesCount
            )
        }
    }
}
