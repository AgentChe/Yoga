//
//  PlanDrill.swift
//  Soccer
//
//  Created by Андрей Чернышев on 08.03.2023.
//

import Foundation

struct PlanDrill: Codable, Hashable {
    let customerDrillId: Int
    let name: String
    let image: URL
    let levelId: Int
    let status: PlanStatus
    let categoryId: Int
}
