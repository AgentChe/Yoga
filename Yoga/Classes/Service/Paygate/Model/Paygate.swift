//
//  Paygate.swift
//  Soccer
//
//  Created by Андрей Чернышев on 08.02.2023.
//

struct Paygate: Codable, Hashable {
    let leftOptionConfig: PaygateOptionConfig
    let rightOptionConfig: PaygateOptionConfig
}
