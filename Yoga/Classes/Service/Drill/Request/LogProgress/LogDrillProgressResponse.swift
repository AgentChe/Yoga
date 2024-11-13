//
//  LogDrillProgressResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Foundation

final class LogDrillProgressResponse {
    static func map(from response: Any) -> AssignedDrill? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let customerDrillId = data["customer_drill_id"] as? Int,
            let finished = data["finished"] as? Bool,
            let trainedTime = data["trained_time"] as? Int
        else {
            return nil
        }
        
        var scheduleDate: Date? = nil
        if let scheduleTimestamp = data["schedule_date"] as? TimeInterval {
            scheduleDate = Date(timeIntervalSince1970: scheduleTimestamp)
        }
        
        return AssignedDrill(
            customerDrillId: customerDrillId,
            scheduleDate: scheduleDate,
            finished: finished,
            trainedTime: trainedTime
        )
    }
}
