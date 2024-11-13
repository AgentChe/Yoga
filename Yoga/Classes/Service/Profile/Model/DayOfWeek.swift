//
//  DayOfWeek.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.02.2023.
//

enum DayOfWeek: Codable, Hashable {
    case su, mo, tu, we, th, fr, sa
}

// MARK: Public
extension DayOfWeek {
    init?(code: String) {
        switch code {
        case "su":
            self = .su
        case "mo":
            self = .mo
        case "tu":
            self = .tu
        case "we":
            self = .we
        case "th":
            self = .th
        case "fr":
            self = .fr
        case "sa":
            self = .sa
        default:
            return nil
        }
    }
    
    var code: String {
        switch self {
        case .su:
            return "su"
        case .mo:
            return "mo"
        case .tu:
            return "tu"
        case .we:
            return "we"
        case .th:
            return "th"
        case .fr:
            return "fr"
        case .sa:
            return "sa"
        }
    }
}
