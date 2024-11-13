//
//  GetPlanResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 08.03.2023.
//

import Foundation

final class GetPlanResponse {
    static func map(from response: Any) -> [PlanOnDay] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let plan = data["plan"] as? [String: [String: Any]]
        else {
            return []
        }
        
        return map(planJSON: plan)
    }
    
    static func map(planJSON: [String: [String: Any]]) -> [PlanOnDay] {
        planJSON.compactMap { day, planJSON -> PlanOnDay? in
            guard
                let day = TimeInterval(day),
                let statusCode = planJSON["status"] as? Int,
                let status = Self.status(from: statusCode)
            else {
                return nil
            }

            let drillsArray = planJSON["drills"] as? [[String: Any]]
            let workoutArray = planJSON["workouts"] as? [[String: Any]]

            let drills = (drillsArray ?? []).compactMap { drillJSON -> PlanDrill? in
                guard
                    let customerDrillId = drillJSON["customer_drill_id"] as? Int,
                    let name = drillJSON["name"] as? String,
                    let imagePath = drillJSON["image"] as? String,
                    let imageUrl = URL(string: imagePath),
                    let levelId = drillJSON["level_id"] as? Int,
                    let statusCode = drillJSON["status"] as? Int,
                    let status = Self.status(from: statusCode),
                    let categoryId = drillJSON["drill_category_id"] as? Int
                else {
                    return nil
                }

                return PlanDrill(
                    customerDrillId: customerDrillId,
                    name: name,
                    image: imageUrl,
                    levelId: levelId,
                    status: status,
                    categoryId: categoryId
                )
            }

            let workouts = (workoutArray ?? []).compactMap { workoutJSON -> PlanWorkout? in
                guard
                    let customerWorkoutId = workoutJSON["customer_workout_id"] as? Int,
                    let name = workoutJSON["name"] as? String,
                    let imagePath = workoutJSON["image"] as? String,
                    let imageUrl = URL(string: imagePath),
                    let levelId = workoutJSON["level_id"] as? Int,
                    let statusCode = workoutJSON["status"] as? Int,
                    let status = Self.status(from: statusCode)
                else {
                    return nil
                }

                return PlanWorkout(
                    customerWorkoutId: customerWorkoutId,
                    name: name,
                    image: imageUrl,
                    levelId: levelId,
                    status: status
                )
            }

            return PlanOnDay(
                day: Date(timeIntervalSince1970: day),
                status: status,
                drills: drills,
                workouts: workouts
            )
        }
    }
}

// MARK: Private
private extension GetPlanResponse {
    static func status(from code: Int) -> PlanStatus? {
        switch code {
        case -1:
            return .skipped
        case 0:
            return .planned
        case 1:
            return .completed
        default:
            return nil
        }
    }
}
