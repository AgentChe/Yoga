//
//  Role.swift
//  Soccer
//
//  Created by Андрей Чернышев on 01.02.2023.
//

enum SoccerRole: Codable, Hashable {
    case player, coach, amateur
}

// MARK: Public
extension SoccerRole {
    init?(code: Int) {
        switch code {
        case 0:
            self = .player
        case 1:
            self = .coach
        case 2:
            self = .amateur
        default:
            return nil
        }
    }
    
    var code: Int {
        switch self {
        case .player:
            return 0
        case .coach:
            return 1
        case .amateur:
            return 2
        }
    }
}
