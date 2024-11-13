//
//  ProfileDetailsTableElement.swift
//  Soccer
//
//  Created by Виталий Загороднов on 29.04.2023.
//

import Foundation

enum ProfileDetailsTableElement {
    case item(type: CellType, isLast: Bool = false, subtitle: String? = nil)
    case header(String)
    
    enum CellType {
        case skillLevel
        case trainingDays
        case focusZone
        case goals
        case termsOfUse
        case privatePolicy
        case contactUs
    }
}


