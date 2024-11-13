//
//  WorkoutTemplateTableElement.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import UIKit

enum WorkoutTemplateTableElement {
    case offset(CGFloat)
    case header(WorkoutTemplateHeaderElement)
    case buttons
    case focusZones([FocusZone])
    case title(String)
    case exercise(WorkoutExercise)
}

struct WorkoutTemplateHeaderElement {
    let image: URL
    let name: String
    let skillLevel: String
    let exerciseCount: Int
}
