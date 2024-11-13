//
//  GetProfileResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 03.02.2023.
//

final class GetProfileResponse {
    static func map(from response: Any) -> Profile? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any]
        else {
            return nil
        }
        
        let skillLevelId = data["level_id"] as? Int
        
        let weekScheduleArray = data["training_days"] as? [Int] ?? []
        let weekSchedule = WeekSchedule(
            su: weekScheduleArray.contains(0),
            mo: weekScheduleArray.contains(1),
            tu: weekScheduleArray.contains(2),
            we: weekScheduleArray.contains(3),
            th: weekScheduleArray.contains(4),
            fr: weekScheduleArray.contains(5),
            sa: weekScheduleArray.contains(6)
        )
        
        let drillsIds = data["drill_category_ids"] as? [Int]
        
        let focusZonesIds = data["body_part_ids"] as? [Int]
        
        let gender = (data["gender"] as? Int).flatMap { Gender(code: $0)}
        
        return Profile(
            skillLevelId: skillLevelId,
            gender: gender,
            weekSchedule: weekSchedule,
            drillsIds: drillsIds,
            focusZonesIds: focusZonesIds
        )
    }
}
