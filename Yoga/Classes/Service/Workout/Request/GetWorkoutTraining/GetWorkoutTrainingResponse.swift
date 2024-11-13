//
//  GetWorkoutTrainingResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 08.03.2023.
//

import Foundation

final class GetWorkoutTrainingResponse {
    static func map(from response: Any) -> WorkoutTraining? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let id = data["template_workout_id"] as? Int,
            let name = data["name"] as? String,
            let imagePath = data["image"] as? String,
            let imageUrl = URL(string: imagePath),
            let levelId = data["level_id"] as? Int,
            let exercisesBundleArray = data["training_steps"] as? [[String: Any]],
            let customerWorkoutId = data["customer_workout_id"] as? Int,
            let finished = data["finished"] as? Bool,
            let trainedTime = data["trained_time"] as? Int
        else {
            return nil
        }
        
        let exercises = exercisesBundleArray.reduce([]) { result, exercisesBundleJSON -> [WorkoutExercise] in
            guard let exercisesArray = exercisesBundleJSON["exercises"] as? [[String: Any]] else {
                return result
            }
            
            let exercises = exercisesArray.compactMap { exerciseJSON -> WorkoutExercise? in
                guard
                    let id = exerciseJSON["exercise_id"] as? Int,
                    let name = exerciseJSON["name"] as? String,
                    let subTitle = exerciseJSON["subtitle"] as? String,
                    let imagePath = exerciseJSON["image"] as? String,
                    let imageUrl = URL(string: imagePath),
                    let instruction = exerciseJSON["instruction"] as? String
                else {
                    return nil
                }
                
                return WorkoutExercise(
                    id: id,
                    name: name,
                    subTitle: subTitle,
                    image: imageUrl,
                    instruction: instruction
                )
            }
            
            return result + exercises
        }
        
        let template = WorkoutTemplate(
            id: id,
            name: name,
            image: imageUrl,
            levelId: levelId,
            focusZonesIds: data["body_part_ids"] as? [Int],
            exercises: exercises
        )
        
        var scheduleDate: Date? = nil
        if let scheduleTimestamp = data["schedule_date"] as? TimeInterval {
            scheduleDate = Date(timeIntervalSince1970: scheduleTimestamp)
        }
        
        let assignedWorkout = AssignedWorkout(
            customerWorkoutId: customerWorkoutId,
            scheduleDate: scheduleDate,
            finished: finished,
            trainedTime: trainedTime
        )
        
        return WorkoutTraining(
            template: template,
            assignedWorkout: assignedWorkout
        )
    }
}
