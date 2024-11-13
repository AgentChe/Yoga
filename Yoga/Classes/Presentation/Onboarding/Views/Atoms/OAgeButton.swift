//
//  OAgeButton.swift
//  Soccer
//
//  Created by Андрей Чернышев on 01.02.2023.
//

import UIKit

final class OAgeButton: UIButton {
    lazy var marked = false {
        didSet {
            update()
        }
    }
    
    lazy var ageLabel = makeLabel()
    
    private let age: String
    
    init(age: String) {
        self.age = age
        
        super.init(frame: .zero)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OAgeButton {
    func update() {
        layer.borderColor = marked ? Appearance.main300.cgColor : UIColor.clear.cgColor
        layer.borderWidth = marked ? 1.scale : 0
    }
}

// MARK: Make constraints
private extension OAgeButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            ageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            ageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OAgeButton {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
            .lineHeight(25.6.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = age.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
