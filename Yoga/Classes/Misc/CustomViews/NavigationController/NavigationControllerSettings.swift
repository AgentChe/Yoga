//
//  NursingNavigationControllerSettings.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

struct NavigationControllerSettings {
    let backgroundImage: UIImage
    let shadowImage: UIImage
    let isTranslucent: Bool
    let tintColor: UIColor
    let titleTextAttrributes: [NSAttributedString.Key: Any]
}

// MARK: Make
extension NavigationControllerSettings {
    static func `default`() -> NavigationControllerSettings {
        NavigationControllerSettings(backgroundImage: UIImage(),
                                     shadowImage: UIImage(),
                                     isTranslucent: true,
                                     tintColor: Appearance.mono100,
                                     titleTextAttrributes: TextAttributes()
                                        .textColor(Appearance.mono100)
                                        .font(Fonts.Inter.bold(size: 20.scale))
                                        .textAlignment(.center)
                                        .dictionary)
    }
}
