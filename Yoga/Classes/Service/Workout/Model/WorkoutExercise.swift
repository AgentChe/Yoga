//
//  WorkoutExercise.swift
//  Soccer
//
//  Created by Андрей Чернышев on 08.03.2023.
//

import Foundation

struct WorkoutExercise: Codable, Hashable {
    let id: Int
    let name: String
    let subTitle: String
    let image: URL
    let instruction: String
}
