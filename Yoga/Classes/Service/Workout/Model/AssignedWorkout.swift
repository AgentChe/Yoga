//
//  AssignedWorkout.swift
//  Soccer
//
//  Created by Андрей Чернышев on 08.03.2023.
//

import Foundation

struct AssignedWorkout: Codable, Hashable {
    let customerWorkoutId: Int
    let scheduleDate: Date?
    let finished: Bool
    let trainedTime: Int
}
