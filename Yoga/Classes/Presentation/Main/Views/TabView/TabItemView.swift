//
//  TabItemView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit

final class TabItemView: UIButton {
    enum Mode {
        case selected, deselected
    }
    
    lazy var iconView = makeImageView()
    lazy var label = makeLabel()
    
    var mode = Mode.deselected {
        didSet {
            update()
        }
    }
    
    private let code: String
    
    init(code: String) {
        self.code = code
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TabItemView {
    func update() {
        let color: UIColor
        let image: UIImage?
        
        switch mode {
        case .selected:
            color = Appearance.main300
            image = UIImage(named: code + ".Selected")
            alpha = 1
        case .deselected:
            color = Appearance.mono100
            image = UIImage(named: code + ".Deselected")
            alpha = 0.5
        }
        
        let attrs = TextAttributes()
            .font(Fonts.PlusJakartaSans.semiBold(size: 11.scale))
            .textColor(color)
            .lineHeight(12.scale)
            .textAlignment(.center)
        label.attributedText = code.localized.attributed(with: attrs)
        
        iconView.image = image
    }
}

// MARK: Make constraints
private extension TabItemView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 5.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 6.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TabItemView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
