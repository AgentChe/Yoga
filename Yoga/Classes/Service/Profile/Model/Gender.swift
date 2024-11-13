//
//  Gender.swift
//  Soccer
//
//  Created by Андрей Чернышев on 01.02.2023.
//

enum Gender: Codable, Hashable {
    case male, female
}

// MARK: Public
extension Gender {
    init?(code: Int) {
        switch code {
        case 0:
            self = .male
        case 1:
            self = .female
        default:
            return nil
        }
    }
    
    var code: Int {
        switch self {
        case .male:
            return 0
        case .female:
            return 1
        }
    }
}
