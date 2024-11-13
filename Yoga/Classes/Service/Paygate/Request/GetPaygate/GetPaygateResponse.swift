//
//  GetPaygateResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 27.12.2022.
//

import UIKit

final class GetPaygateResponse {
    static func map(from response: Any) throws -> Paygate? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let optionLeftJSON = data["option_left"] as? [String: Any],
            let leftConfig = map(optionJSON: optionLeftJSON),
            let optionRightJSON = data["option_right"] as? [String: Any],
            let rightConfig = map(optionJSON: optionRightJSON)
        else {
            return nil
        }
        
        return Paygate(leftOptionConfig: leftConfig,
                       rightOptionConfig: rightConfig)
    }
}

// MARK: Private
private extension GetPaygateResponse {
    static func map(optionJSON: [String: Any]) -> PaygateOptionConfig? {
        guard
            let productId = optionJSON["product_id"] as? String,
            let linesJSON = optionJSON["lines"] as? [String: Any]
        else {
            return nil
        }
        
        let line1JSON = linesJSON["1"] as? [[String: Any]]
        let line2JSON = linesJSON["2"] as? [[String: Any]]
        let line3JSON = linesJSON["3"] as? [[String: Any]]
        let line4JSON = linesJSON["4"] as? [[String: Any]]
        let line5JSON = linesJSON["5"] as? [[String: Any]]
        
        return PaygateOptionConfig(productId: productId,
                                   line1: map(lineJSON: line1JSON),
                                   line2: map(lineJSON: line2JSON),
                                   line3: map(lineJSON: line3JSON),
                                   line4: map(lineJSON: line4JSON),
                                   line5: map(lineJSON: line5JSON))
    }
    
    static func map(lineJSON: [[String: Any]]?) -> [PaygateOptionLineComponent]? {
        guard let lineJSON = lineJSON else {
            return nil
        }
        
        return lineJSON.compactMap { json -> PaygateOptionLineComponent? in
            map(lineComponentJSON: json)
        }
    }
    
    static func map(lineComponentJSON: [String: Any]?) -> PaygateOptionLineComponent? {
        guard let lineComponentJSON = lineComponentJSON else {
            return nil
        }
        
        guard
            let type = lineComponentJSON["type"] as? String,
            let weightValue = lineComponentJSON["weight"] as? String,
            let size = lineComponentJSON["size"] as? CGFloat
        else {
            return nil
        }
        
        let weight = map(weight: weightValue, size: size)
        
        switch type {
        case "text":
            guard let value = lineComponentJSON["value"] as? String else {
                return nil
            }
            
            return PaygateOptionLineComponent(component: .text(value), weight: weight)
        case "price_div":
            guard let value = lineComponentJSON["value"] as? Int else {
                return nil
            }
            
            return PaygateOptionLineComponent(component: .price(value), weight: weight)
        case "promo":
            guard let value = lineComponentJSON["value"] as? String else {
                return nil
            }
            
            return PaygateOptionLineComponent(component: .promo(value), weight: weight)
        default:
            return nil
        }
    }
    
    static func map(weight: String, size: CGFloat) -> PaygateOptionLineComponent.Weight {
        switch weight {
        case "bold":
            return .bold(size)
        case "semibold":
            return .semiBold(size)
        case "regular":
            return .regular(size)
        default:
            return .regular(size)
        }
    }
}
