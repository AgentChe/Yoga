//
//  WorkoutTemplate.swift
//  Soccer
//
//  Created by Андрей Чернышев on 08.03.2023.
//

import Foundation

struct WorkoutTemplate: Codable, Hashable {
    let id: Int
    let name: String
    let image: URL
    let levelId: Int
    let focusZonesIds: [Int]?
    let exercises: [WorkoutExercise]
}
