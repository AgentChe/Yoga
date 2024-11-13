//
//  GetWorkoutStepsResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.03.2023.
//

import Foundation

final class GetWorkoutStepsResponse {
    static func map(from response: Any) -> [WorkoutStep] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let stepsArray = data["training_steps"] as? [[String: Any]]
        else {
            return []
        }
        
        return stepsArray.compactMap { stepJSON -> WorkoutStep? in
            guard
                let id = stepJSON["training_step_id"] as? Int,
                let name = stepJSON["name"] as? String,
                let imagePath = stepJSON["image"] as? String,
                let imageUrl = URL(string: imagePath),
                let paid = stepJSON["paid"] as? Bool,
                let exercisesCount = stepJSON["exercises_count"] as? Int
            else {
                return nil
            }
            
            return WorkoutStep(
                id: id,
                name: name,
                image: imageUrl,
                paid: paid,
                exercisesCount: exercisesCount
            )
        }
    }
}
