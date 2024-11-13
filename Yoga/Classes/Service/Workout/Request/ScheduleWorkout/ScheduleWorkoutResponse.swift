//
//  ScheduleWorkoutResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 08.03.2023.
//

import Foundation

final class ScheduleWorkoutResponse {
    static func map(from response: Any) -> AssignedWorkout? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let customerWorkoutId = data["customer_workout_id"] as? Int,
            let finished = data["finished"] as? Bool,
            let trainedTime = data["trained_time"] as? Int
        else {
            return nil
        }
        
        var scheduleDate: Date? = nil
        if let scheduleTimestamp = data["schedule_date"] as? TimeInterval {
            scheduleDate = Date(timeIntervalSince1970: scheduleTimestamp)
        }
        
        return AssignedWorkout(
            customerWorkoutId: customerWorkoutId,
            scheduleDate: scheduleDate,
            finished: finished,
            trainedTime: trainedTime
        )
    }
}
