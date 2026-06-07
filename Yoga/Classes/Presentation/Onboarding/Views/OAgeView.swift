//
//  OAgeView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 01.02.2023.
//

import UIKit

final class OAgeView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var age1Button = makeAgeButton(age: "Onboarding.Age.1".localized)
    lazy var age2Button = makeAgeButton(age: "Onboarding.Age.2".localized)
    lazy var age3Button = makeAgeButton(age: "Onboarding.Age.3".localized)
    lazy var age4Button = makeAgeButton(age: "Onboarding.Age.4".localized)
    lazy var age5Button = makeAgeButton(age: "Onboarding.Age.5".localized)
    lazy var continueButton = makeContinueButton()
    
    private lazy var buttons = [
        age1Button,
        age2Button,
        age3Button,
        age4Button,
        age5Button
    ]
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
        checkEnabled()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OAgeView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
    
    @objc
    func ageTapped(sender: UIButton) {
        guard let ageButton = sender as? OAgeButton else {
            return
        }
        
        buttons.forEach { $0.marked = false }
        ageButton.marked = true
        
        checkEnabled()
    }
    
    func checkEnabled() {
        let marked = buttons.contains(where: { $0.marked })
        continueButton.isHidden = !marked
    }
}

// MARK: Make constraints
private extension OAgeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 120.scale : 52.scale),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            age1Button.widthAnchor.constraint(equalToConstant: 343.scale),
            age1Button.heightAnchor.constraint(equalToConstant: 80.scale),
            age1Button.centerXAnchor.constraint(equalTo: centerXAnchor),
            age1Button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 30.scale : 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            age2Button.widthAnchor.constraint(equalToConstant: 343.scale),
            age2Button.heightAnchor.constraint(equalToConstant: 80.scale),
            age2Button.centerXAnchor.constraint(equalTo: centerXAnchor),
            age2Button.topAnchor.constraint(equalTo: age1Button.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            age3Button.widthAnchor.constraint(equalToConstant: 343.scale),
            age3Button.heightAnchor.constraint(equalToConstant: 80.scale),
            age3Button.centerXAnchor.constraint(equalTo: centerXAnchor),
            age3Button.topAnchor.constraint(equalTo: age2Button.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            age4Button.widthAnchor.constraint(equalToConstant: 343.scale),
            age4Button.heightAnchor.constraint(equalToConstant: 80.scale),
            age4Button.centerXAnchor.constraint(equalTo: centerXAnchor),
            age4Button.topAnchor.constraint(equalTo: age3Button.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            age5Button.widthAnchor.constraint(equalToConstant: 343.scale),
            age5Button.heightAnchor.constraint(equalToConstant: 80.scale),
            age5Button.centerXAnchor.constraint(equalTo: centerXAnchor),
            age5Button.topAnchor.constraint(equalTo: age4Button.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 54.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -62.scale : -32.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OAgeView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.bold(size: 24.scale))
            .lineHeight(28.8.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Age.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAgeButton(age: String) -> OAgeButton {
        let view = OAgeButton(age: age)
        view.backgroundColor = Appearance.main200
        view.layer.cornerRadius = 10.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(ageTapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.semiBold(size: 16.scale))
        
        let view = UIButton()
        view.backgroundColor = Appearance.main300
        view.layer.cornerRadius = 28.scale
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
