//
//  PaygateProductButton.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.09.2022.
//

import UIKit

final class PaygateProductButton: UIButton {
    var isChecked: Bool = false {
        didSet {
            update()
        }
    }
    
    var info: PaygateOptionInfo? {
        didSet {
            update()
        }
    }
    
    lazy var checkedView = makeCheckedView()
    lazy var line1Label = makeLabel()
    lazy var line2Label = makeLabel()
    lazy var line3Label = makeLabel()
    lazy var discountPlaceholderView = makeDiscountPlaceholderView()
    lazy var discountLabel = makeLabel()
    lazy var line5Label = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension PaygateProductButton {
    func update() {
        changeSelection()
        configure()
    }
    
    func changeSelection() {
        layer.borderWidth = 2.scale
        layer.borderColor = isChecked ? Appearance.main300.cgColor : Appearance.main200.cgColor
        
        checkedView.isHidden = !isChecked
    }
    
    func configure() {
        guard let info = info else {
            return
        }
        
        line1Label.attributedText = info.line1
        line1Label.isHidden = info.line1 == nil
        
        line2Label.attributedText = info.line2
        line2Label.isHidden = info.line2 == nil
        
        line3Label.attributedText = info.line3
        line3Label.isHidden = info.line3 == nil
        
        discountLabel.attributedText = info.line4
        discountLabel.isHidden = info.line4 == nil
        discountPlaceholderView.isHidden = info.line4 == nil
        
        line5Label.attributedText = info.line5
        line5Label.isHidden = info.line5 == nil
    }
}

// MARK: Make constraints
private extension PaygateProductButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            checkedView.widthAnchor.constraint(equalToConstant: 24.scale),
            checkedView.heightAnchor.constraint(equalToConstant: 24.scale),
            checkedView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.scale),
            checkedView.topAnchor.constraint(equalTo: topAnchor, constant: 13.scale)
        ])
        
        NSLayoutConstraint.activate([
            line1Label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale),
            line1Label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -127.scale)
        ])
        
        NSLayoutConstraint.activate([
            line2Label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale),
            line2Label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -91.scale)
        ])
        
        NSLayoutConstraint.activate([
            line3Label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale),
            line3Label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -74.scale)
        ])
        
        NSLayoutConstraint.activate([
            discountPlaceholderView.heightAnchor.constraint(equalToConstant: 23.scale),
            discountPlaceholderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale),
            discountPlaceholderView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -47.scale)
        ])
        
        NSLayoutConstraint.activate([
            discountLabel.leadingAnchor.constraint(equalTo: discountPlaceholderView.leadingAnchor, constant: 2.scale),
            discountLabel.trailingAnchor.constraint(equalTo: discountPlaceholderView.trailingAnchor, constant: -2.scale),
            discountLabel.topAnchor.constraint(equalTo: discountPlaceholderView.topAnchor, constant: 3.scale),
            discountLabel.bottomAnchor.constraint(equalTo: discountPlaceholderView.bottomAnchor, constant: -3.scale)
        ])
        
        NSLayoutConstraint.activate([
            line5Label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale),
            line5Label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateProductButton {
    func makeCheckedView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Paygate.Checked")
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
    
    func makeDiscountPlaceholderView() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main500
        view.layer.cornerRadius = 4.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
