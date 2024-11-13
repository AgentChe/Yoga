//
//  WorkoutCover.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import Foundation

struct WorkoutCover: Codable, Hashable {
    let id: Int
    let name: String
    let image: URL
    let paid: Bool
    let exercisesCount: Int
}
