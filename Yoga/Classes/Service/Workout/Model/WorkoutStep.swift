//
//  WorkoutStep.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.03.2023.
//

import Foundation

struct WorkoutStep: Codable, Hashable {
    let id: Int
    let name: String
    let image: URL
    let paid: Bool
    let exercisesCount: Int
}
