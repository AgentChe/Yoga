//
//  Collection+Extension.swift
//  Soccer
//
//  Created by Андрей Чернышев on 15.07.2022.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
