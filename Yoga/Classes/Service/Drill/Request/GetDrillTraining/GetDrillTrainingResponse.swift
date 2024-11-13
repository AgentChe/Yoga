//
//  GetDrillTrainingResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Foundation

final class GetDrillTrainingResponse {
    static func map(from response: Any) -> DrillTraining? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let id = data["drill_id"] as? Int,
            let name = data["name"] as? String,
            let skillLevelId = data["level_id"] as? Int,
            let imagePath = data["image"] as? String,
            let imageUrl = URL(string: imagePath),
            let categoryId = data["drill_category_id"] as? Int,
            let instruction = data["description"] as? String,
            let customerDrillId = data["customer_drill_id"] as? Int,
            let finished = data["finished"] as? Bool,
            let trainedTime = data["trained_time"] as? Int
        else {
            return nil
        }
        
        let paid = data["paid"] as? Bool
        
        let drill = Drill(
            id: id,
            name: name,
            skillLevelId: skillLevelId,
            image: imageUrl,
            categoryId: categoryId,
            paid: paid ?? false,
            instruction: instruction
        )
        
        var scheduleDate: Date? = nil
        if let scheduleTimestamp = data["schedule_date"] as? TimeInterval {
            scheduleDate = Date(timeIntervalSince1970: scheduleTimestamp)
        }
        
        let assignedDrill = AssignedDrill(
            customerDrillId: customerDrillId,
            scheduleDate: scheduleDate,
            finished: finished,
            trainedTime: trainedTime
        )
        
        return DrillTraining(
            drill: drill,
            assignedDrill: assignedDrill
        )
    }
}
