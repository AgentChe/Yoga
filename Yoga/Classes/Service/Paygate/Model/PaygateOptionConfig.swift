//
//  PaygateOptionConfig.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.02.2023.
//

struct PaygateOptionConfig: Codable, Hashable {
    let productId: String
    let line1: [PaygateOptionLineComponent]?
    let line2: [PaygateOptionLineComponent]?
    let line3: [PaygateOptionLineComponent]?
    let line4: [PaygateOptionLineComponent]?
    let line5: [PaygateOptionLineComponent]?
}
