//
//  MainViewCoordinator.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit

final class MainViewCoordinator {
    weak var parentVC: MainViewController?
    
    lazy var homeVC = NavigationController(rootViewController: HomeViewController.make(seeAllWorkouts: { [weak self] in
        self?.change(tab: .train)
    }, addTrainings: { [weak self] in
        self?.change(tab: .train)
    }))
    lazy var trainVC = NavigationController(rootViewController: trainController)
    lazy var profileVC = NavigationController(rootViewController: ProfileMainViewController.make())
    
    private lazy var trainController = TrainViewController.make { [weak self] in
        self?.change(tab: .profile)
    }
    
    private var previousVC: UIViewController?
    
    init(parentVC: MainViewController) {
        self.parentVC = parentVC
    }
    
    func change(tab: TabView.Tab) {
        parentVC?.mainView.tabView.selectedTab = tab
        
        switch tab {
        case .home:
            changeVC(on: homeVC)
        case .train:
            changeVC(on: trainVC)
        case .profile:
            changeVC(on: profileVC)
        }
    }
}

// MARK: Private
private extension MainViewCoordinator {
    func changeVC(on vc: UIViewController) {
        if let previousVC = self.previousVC {
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
        }
    
        self.previousVC = vc
        
        guard let parentVC = self.parentVC else {
            return
        }
    
        parentVC.addChild(vc)
        vc.view.frame = parentVC.mainView.container.bounds
        parentVC.mainView.container.addSubview(vc.view)
        vc.willMove(toParent: parentVC)
    }
}
