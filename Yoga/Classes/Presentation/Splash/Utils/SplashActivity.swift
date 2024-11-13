//
//  SplashActivity.swift
//  Soccer
//
//  Created by Андрей Чернышев on 05.07.2022.
//

enum SplashActivity {
    case none, sdkInitialize, library
    
    var text: String {
        switch self {
        case .none:
            return ""
        case .sdkInitialize:
            let isFirstLaunch = NumberLaunches().isFirstLaunch()
            return isFirstLaunch ? "Splash.Preloader3".localized : "Splash.Preloader1".localized
        case .library:
            return "Splash.Preloader2".localized
        }
    }
}
