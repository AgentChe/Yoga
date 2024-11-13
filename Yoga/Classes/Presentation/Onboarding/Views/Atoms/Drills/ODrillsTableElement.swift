//
//  ODrillsTableElement.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.02.2023.
//

final class ODrillsTableElement {
    let drillCategory: DrillCategory
    var marked: Bool
    
    init(drillCategory: DrillCategory, marked: Bool = false) {
        self.drillCategory = drillCategory
        self.marked = marked
    }
}
