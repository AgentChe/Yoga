//
//  OGenderView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 01.02.2023.
//

import UIKit

protocol OGenderViewDelegate: AnyObject {
    func genderViewDidSelect(gender: Gender)
}

final class OGenderView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var maleButton = makeGenderButton(gender: .male)
    lazy var femaleButton = makeGenderButton(gender: .female)
    lazy var continueButton = makeContinueButton()
    
    private var delegates = [Weak<OGenderViewDelegate>]()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
        checkEnabled()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        AmplitudeManager.shared
            .logEvent(name: "Gender Screen")
    }
}

// MARK: Public (Observer)
extension OGenderView {
    func add(delegate: OGenderViewDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<OGenderViewDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(delegate: OGenderViewDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}

// MARK: Private
private extension OGenderView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
    
    @objc
    func nextTapped() {
        guard let gender = [maleButton, femaleButton].first(where: { $0.marked })?.gender else {
            return
        }
        
        delegates.forEach { $0.weak?.genderViewDidSelect(gender: gender) }
        
        onNext()
    }
    
    @objc
    func tapped(sender: UIButton) {
        guard let genderButton = sender as? OGenderButton else {
            return
        }
        
        [maleButton, femaleButton].forEach { $0.marked = false }
        genderButton.marked = true
        
        checkEnabled()
    }
    
    func checkEnabled() {
        let marked = [maleButton, femaleButton].contains(where: { $0.marked })
        continueButton.isHidden = !marked
    }
}

// MARK: Make constraints
private extension OGenderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 140.scale : 52.scale),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            maleButton.widthAnchor.constraint(equalToConstant: 164.scale),
            maleButton.heightAnchor.constraint(equalToConstant: 194.scale),
            maleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            maleButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            femaleButton.widthAnchor.constraint(equalToConstant: 164.scale),
            femaleButton.heightAnchor.constraint(equalToConstant: 194.scale),
            femaleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 196.scale),
            femaleButton.centerYAnchor.constraint(equalTo: centerYAnchor)
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
private extension OGenderView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.bold(size: 24.scale))
            .lineHeight(28.8.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Gender.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeGenderButton(gender: Gender) -> OGenderButton {
        let view = OGenderButton(gender: gender)
        view.backgroundColor = Appearance.main200
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
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
        view.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
