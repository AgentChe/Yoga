//
//  NursingNavigationController.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apply(settings: .default())
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

// MARK: API
extension NavigationController {
    func apply(settings: NavigationControllerSettings) {
        navigationBar.setBackgroundImage(settings.backgroundImage, for: .default)
        navigationBar.shadowImage = settings.shadowImage
        navigationBar.isTranslucent = settings.isTranslucent
        navigationBar.tintColor = settings.tintColor
        navigationBar.titleTextAttributes = settings.titleTextAttrributes
    }
}
