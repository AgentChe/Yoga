//
//  WorkoutTrainingAssembly.swift
//  Soccer
//
//  Created by Виталий Загороднов on 23.03.2023.
//

import UIKit

final class WorkoutTrainingAssembly {}

// MARK: Public
extension WorkoutTrainingAssembly {
    func startTraining(from parent: UIViewController, customerWorkoutId: Int) {
        let vc = WorkoutTrainingViewController.make(customerWorkoutId: customerWorkoutId) { workoutTraining in
            let resultVC = WorkoutTrainingResultViewController.make(workoutTraining: workoutTraining)
            
            parent.present(resultVC, animated: true)
        }
        
        parent.present(vc, animated: true)
    }
}
