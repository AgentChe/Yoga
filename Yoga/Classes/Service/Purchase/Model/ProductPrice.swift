//
//  ProductPrice.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.03.2022.
//

import StoreKit

struct ProductPrice {
    let id: String
    let priceLocalized: String
    let priceValue: Double
    let priceLocale: Locale
    let currency: String
}

// MARK: Make
extension ProductPrice {
    init(product: SKProduct) {
        id = product.productIdentifier
        priceLocalized = product.localizedPrice ?? ""
        priceValue = product.price.doubleValue
        priceLocale = product.priceLocale
        currency = product.priceLocale.currencyCode ?? ""
    }
}
