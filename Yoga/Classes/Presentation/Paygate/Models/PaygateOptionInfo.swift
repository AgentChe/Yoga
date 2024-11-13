//
//  PaygateOptionInfo.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.02.2023.
//

import UIKit

struct PaygateOptionInfo {
    let productId: String
    let line1: NSAttributedString?
    let line2: NSAttributedString?
    let line3: NSAttributedString?
    let line4: NSAttributedString?
    let line5: NSAttributedString?
    
    init(config: PaygateOptionConfig, price: ProductPrice) {
        productId = config.productId
        line1 = Self.build(line: config.line1, price: price)
        line2 = Self.build(line: config.line2, price: price)
        line3 = Self.build(line: config.line3, price: price)
        line4 = Self.build(line: config.line4, price: price)
        line5 = Self.build(line: config.line5, price: price)
    }
}

// MARK: Private
private extension PaygateOptionInfo {
    static func build(line: [PaygateOptionLineComponent]?, price: ProductPrice) -> NSAttributedString? {
        guard let line = line else {
            return nil
        }
        
        return line
            .compactMap { component -> NSAttributedString? in
                let attrs = TextAttributes()
                    .textColor(Appearance.mono100)
                    .font(font(at: component.weight))
                
                let formatter = formatter(locale: price.priceLocale)
                
                switch component.component {
                case .text(let text):
                    return text.attributed(with: attrs)
                case .price(let priceDiv):
                    let priceResult = price.priceValue / Double(priceDiv)
                    
                    let priceResultLocalized: String
                    
                    if priceDiv == 1 {
                        priceResultLocalized = price.priceLocalized
                    } else {
                        if priceResult < 100 {
                            formatter.maximumFractionDigits = 2
                        } else if priceResult < 1000 {
                            formatter.maximumFractionDigits = 1
                        } else {
                            formatter.maximumFractionDigits = 0
                        }
                        
                        priceResultLocalized = formatter.string(from: NSNumber(value: priceResult)) ?? ""
                    }
                    
                    return priceResultLocalized
                        .removingWhitespaces()
                        .attributed(with: attrs)
                case .promo(let promo):
                    let attrs = TextAttributes()
                        .textColor(Appearance.mono200)
                        .font(font(at: component.weight))
                    
                    return promo.attributed(with: attrs)
                }
            }
            .reduce(NSMutableAttributedString()) { result, string -> NSMutableAttributedString in
                result.append(string)
                return result
            }
    }
    
    static func font(at weight: PaygateOptionLineComponent.Weight) -> UIFont {
        switch weight {
        case .bold(let size):
            return Fonts.PlusJakartaSans.bold(size: size.scale)
        case .semiBold(let size):
            return Fonts.PlusJakartaSans.semiBold(size: size.scale)
        case .regular(let size):
            return Fonts.PlusJakartaSans.regular(size: size.scale)
        }
    }
    
    static func formatter(locale: Locale) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        formatter.roundingMode = .down
        return formatter
    }
}
