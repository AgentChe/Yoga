//
//  Drill.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import Foundation

struct Drill: Codable, Hashable {
    let id: Int
    let name: String
    let skillLevelId: Int
    let image: URL
    let categoryId: Int
    let paid: Bool
    let instruction: String
}
