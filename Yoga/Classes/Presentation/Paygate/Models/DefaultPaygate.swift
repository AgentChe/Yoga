//
//  DefaultPaygate.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.02.2023.
//

import UIKit
import OtterScaleiOS

extension Paygate {
    init?(prices: [ProductPrice]) {
        guard
            let lifetimePrice = prices.first(where: { $0.id == GlobalDefinitions.Paygate.defaultLifetime }),
            let monthlyPrice = prices.first(where: { $0.id == GlobalDefinitions.Paygate.defaultMonthly })
        else {
            return nil
        }
        
        self = Paygate(leftOptionConfig: Self.lifetime(lifetimePrice: lifetimePrice,
                                                       monthlyPrice: monthlyPrice),
                       rightOptionConfig: Self.monthly())
    }
}

// MARK: Private
private extension Paygate {
    static func lifetime(lifetimePrice: ProductPrice, monthlyPrice: ProductPrice) -> PaygateOptionConfig {
        let priceDiv: Double = lifetimePrice.priceValue / 12
        
        let diff = monthlyPrice.priceValue - priceDiv
        let discount = 100 / (monthlyPrice.priceValue / diff)
        
        let line1: [PaygateOptionLineComponent] = [
            .init(component: .text("Paygate.Lifetime.Name".localized),
                  weight: .bold(20))
        ]
        let line2: [PaygateOptionLineComponent] = [
            .init(component: .price(12),
                  weight: .semiBold(22)),
            .init(component: .text("/"),
                  weight: .semiBold(22)),
            .init(component: .text("Paygate.Price.Period".localized),
                  weight: .regular(12))
        ]
        let line3: [PaygateOptionLineComponent] = [
            .init(component: .text("Paygate.Lifetime.PriceDescription".localized),
                  weight: .regular(12)),
        ]
        let line4: [PaygateOptionLineComponent] = [
            .init(component: .promo(String(format: "Paygate.Discount".localized, Int(discount))),
                  weight: .bold(14))
        ]
        let line5: [PaygateOptionLineComponent] = [
            .init(component: .price(1),
                  weight: .semiBold(22)),
            .init(component: .text("/"),
                  weight: .semiBold(22)),
            .init(component: .text("Paygate.Lifetime.BottomDescription".localized),
                  weight: .regular(12))
        ]
        
        return PaygateOptionConfig(productId: GlobalDefinitions.Paygate.defaultLifetime,
                                   line1: line1,
                                   line2: line2,
                                   line3: line3,
                                   line4: line4,
                                   line5: line5)
    }
    
    static func monthly() -> PaygateOptionConfig {
        let usedProducts = OtterScale.shared.getUsedProducts()
            .map { $0.appleAppStore } ?? []
        let withTrial = !usedProducts.contains(GlobalDefinitions.Paygate.defaultMonthly)
        
        let line1: [PaygateOptionLineComponent] = [
            .init(component: .text(withTrial ? "Paygate.Monthly.Name1".localized : "Paygate.Monthly.Name2".localized),
                  weight: .bold(20))
        ]
        let line2: [PaygateOptionLineComponent] = [
            .init(component: .price(1),
                  weight: .semiBold(22)),
            .init(component: .text("/"),
                  weight: .semiBold(22)),
            .init(component: .text("Paygate.Price.Period".localized),
                  weight: .regular(12))
        ]
        let line5: [PaygateOptionLineComponent] = [
            .init(component: .text(withTrial ? "Paygate.Monthly.Bottom1".localized : "Paygate.Monthly.Bottom2".localized),
                  weight: .regular(12))
        ]
        
        return PaygateOptionConfig(productId: GlobalDefinitions.Paygate.defaultMonthly,
                                   line1: line1,
                                   line2: line2,
                                   line3: nil,
                                   line4: nil,
                                   line5: line5)
    }
}
