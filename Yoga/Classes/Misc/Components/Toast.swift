//
//  Toast.swift
//  Soccer
//
//  Created by Андрей Чернышев on 01.02.2023.
//

import UIKit
import NotificationBannerSwift

final class Toast {}

// MARK: Public
extension Toast {
    static func notify(with text: String, style: BannerStyle) {
        let attributedText = text.attributed(with: TextAttributes()
            .font(UIFont.systemFont(ofSize: 17.scale, weight: .bold))
            .textColor(UIColor.black)
            .textAlignment(.center))
        
        NotificationBanner(attributedTitle: attributedText, style: style).show()
    }
    
    static func notify(with attributedText: NSAttributedString, style: BannerStyle) {
        NotificationBanner(attributedTitle: attributedText, style: style).show()
    }
}
