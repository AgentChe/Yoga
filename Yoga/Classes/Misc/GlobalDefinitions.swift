//
//  GlobalDefinitions.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

final class GlobalDefinitions {
    static let domain = "https://yoga.thinkaboutapps.com"
    static let apiKey = "VVPAhTnVXD3b43m7nB24"
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "AfQhRjznT7gyI96w"
    
    static let termsOfServiceUrl = URL(string: "https://thinkaboutapps.com/terms")!
    static let privacyPolicyUrl = URL(string: "https://thinkaboutapps.com/policy")!
    static let contactUsUrl = URL(string: "https://thinkaboutapps.com/contact")!
    
    enum Paygate {
        static let defaultLifetime = "train.pilates.endless"
        static let defaultMonthly = "train.pilates.monthly"
    }
}
