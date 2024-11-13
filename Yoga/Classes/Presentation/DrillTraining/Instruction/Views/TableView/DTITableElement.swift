//
//  DTITableElement.swift
//  Soccer
//
//  Created by Андрей Чернышев on 09.02.2023.
//

import UIKit

enum DTITableElement {
    case offset(CGFloat)
    case header(DTIHeaderElement)
    case description(String)
    case buttons
    case instruction(String)
}

struct DTIHeaderElement {
    let image: URL
    let name: String
    let skillLevel: String
    let drillCategory: String
}
