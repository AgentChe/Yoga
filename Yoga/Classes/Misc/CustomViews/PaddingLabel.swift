//
//  PaddingLabel.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

class PaddingLabel: UILabel {
    var insets = UIEdgeInsets(top: 5.scale, left: 7.scale, bottom: 5.scale, right: 7.scale)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + insets.left + insets.right,
                      height: size.height + insets.top + insets.bottom)
    }
}
