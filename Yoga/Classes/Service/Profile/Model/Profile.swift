//
//  Profile.swift
//  Soccer
//
//  Created by Андрей Чернышев on 03.02.2023.
//

struct Profile: Codable, Hashable {
    let skillLevelId: Int?
    let gender: Gender?
    let weekSchedule: WeekSchedule?
    let drillsIds: [Int]?
    let focusZonesIds: [Int]?
}
