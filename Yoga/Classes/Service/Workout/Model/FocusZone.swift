//
//  FocusZone.swift
//  Soccer
//
//  Created by Андрей Чернышев on 03.02.2023.
//

import Foundation

struct FocusZone: Codable, Hashable {
    let id: Int
    let name: String
    let image: URL
    let paid: Bool
    let exercisesCount: Int
}
