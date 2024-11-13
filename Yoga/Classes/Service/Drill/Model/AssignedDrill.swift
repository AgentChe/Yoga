//
//  AssignedDrill.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Foundation

struct AssignedDrill: Codable, Hashable {
    let customerDrillId: Int
    let scheduleDate: Date?
    let finished: Bool
    let trainedTime: Int
}
