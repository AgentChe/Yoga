//
//  DrillTrainingAssembly.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import UIKit

final class DrillTrainingAssembly {}

// MARK: Public
extension DrillTrainingAssembly {
    func startTraining(from parent: UIViewController, customerDrillId: Int) {
        let vc = DrillTrainingViewController.make(customerDrillId: customerDrillId) { drillTraining in
            let resultVC = DrillTrainingResultViewController.make(drillTraining: drillTraining)
            parent.present(resultVC, animated: true)
        }
        parent.present(vc, animated: true)
    }
}
