//
//  OFocusZoneButton.swift
//  Soccer
//
//  Created by Андрей Чернышев on 03.02.2023.
//

import UIKit

final class OFocusZoneButton: UIButton {
    lazy var marked = false {
        didSet {
            update()
        }
    }
    
    lazy var label = makeLabel()
    
    let name: String
    
    init(name: String) {
        self.name = name
        
        super.init(frame: .zero)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OFocusZoneButton {
    func update() {
        backgroundColor = marked ? Appearance.main300 : Appearance.main200
        
        label.textColor = marked ? Appearance.mono200 : Appearance.mono100
    }
}

// MARK: Make constraints
private extension OFocusZoneButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OFocusZoneButton {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
            .lineHeight(25.6.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = name.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
