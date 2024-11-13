//
//  ProfileMainTableElement.swift
//  Soccer
//
//  Created by Виталий Загороднов on 25.04.2023.
//

import Foundation

enum ProfileMainTableElement {
    case offset(CGFloat)
    case profile
    case progress(percent: Int, level: String)
    case calendar([PlanOnDay])
    case planTraining(HomePlanTrainingElement)
    case noTrainings
    case stats(Int)
}
