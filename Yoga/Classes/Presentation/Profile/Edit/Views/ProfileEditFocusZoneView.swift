//
//  ProfileEditFocusZoneView.swift
//  Soccer
//
//  Created by Виталий Загороднов on 29.04.2023.
//

import UIKit
import RxSwift

final class ProfileEditFocusZoneView: UIView {
    var didTapSave: (([FocusZone]) -> Void)?

    lazy var titleLabel = makeTitleLabel()
    lazy var imageView = makeImageView()
    lazy var armsButton = makeFocusZoneButton(name: "Onboarding.FocusZone.Arms".localized)
    lazy var chestButton = makeFocusZoneButton(name: "Onboarding.FocusZone.Chest".localized)
    lazy var coreButton = makeFocusZoneButton(name: "Onboarding.FocusZone.Core".localized)
    lazy var glutesButton = makeFocusZoneButton(name: "Onboarding.FocusZone.Glutes".localized)
    lazy var legsButton = makeFocusZoneButton(name: "Onboarding.FocusZone.Legs".localized)
    lazy var continueButton = makeContinueButton()
    
    private lazy var buttons = [
        armsButton,
        chestButton,
        coreButton,
        glutesButton,
        legsButton
    ]
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var focusZones = [FocusZone]()
    
    private lazy var workoutManager = WorkoutManager()
    
    init(focusZones: [FocusZone], gender: Gender?) {
        super.init(frame: .zero)
        
        makeConstraints()
        initialize(currentZones: focusZones, gender: gender)
        checkEnabled()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ProfileEditFocusZoneView {
    func initialize(currentZones: [FocusZone], gender: Gender?) {
        backgroundColor = Appearance.main100
        
        let image: UIImage?
        switch gender {
        case .female:
            image = UIImage(named: ScreenSize.isIphoneXFamily ? "Onboarding.FocusZone.Female.X" : "Onboarding.FocusZone.Female.8")
        case .male:
            image = UIImage(named: ScreenSize.isIphoneXFamily ? "Onboarding.FocusZone.Male.X" : "Onboarding.FocusZone.Male.8")
        case .none:
            image = nil
        }
        imageView.image = image
        
        workoutManager
            .obtainFocusZones(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
            .drive(Binder(self) { base, focusZones in
                base.focusZones = focusZones
                
                currentZones.forEach { focusZone in
                    if let button = base.buttons.first(where: { $0.name == focusZone.name }) {
                        button.sendActions(for: .touchUpInside)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func focusZoneTapped(sender: UIButton) {
        guard let focusZoneButton = sender as? OFocusZoneButton else {
            return
        }
        
        focusZoneButton.marked.toggle()
        
        checkEnabled()
    }
    
    func checkEnabled() {
        let marked = buttons.contains(where: { $0.marked })
        continueButton.isHidden = !marked
    }
    
    @objc
    func nextTapped() {
        let selectedNames = buttons
            .filter { $0.marked }
            .map { $0.name }
        let selectedZones = focusZones
            .filter { selectedNames.contains($0.name) }
        
        didTapSave?(selectedZones)
    }
}

// MARK: Make constraints
private extension ProfileEditFocusZoneView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 120.scale : 52.scale),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 535.scale : 453.scale)
        ])
        
        NSLayoutConstraint.activate([
            armsButton.widthAnchor.constraint(equalToConstant: 152.scale),
            armsButton.heightAnchor.constraint(equalToConstant: 69.scale),
            armsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            armsButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 61.scale : 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            chestButton.widthAnchor.constraint(equalToConstant: 152.scale),
            chestButton.heightAnchor.constraint(equalToConstant: 69.scale),
            chestButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            chestButton.topAnchor.constraint(equalTo: armsButton.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            coreButton.widthAnchor.constraint(equalToConstant: 152.scale),
            coreButton.heightAnchor.constraint(equalToConstant: 69.scale),
            coreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            coreButton.topAnchor.constraint(equalTo: chestButton.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            glutesButton.widthAnchor.constraint(equalToConstant: 152.scale),
            glutesButton.heightAnchor.constraint(equalToConstant: 69.scale),
            glutesButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            glutesButton.topAnchor.constraint(equalTo: coreButton.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            legsButton.widthAnchor.constraint(equalToConstant: 152.scale),
            legsButton.heightAnchor.constraint(equalToConstant: 69.scale),
            legsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            legsButton.topAnchor.constraint(equalTo: glutesButton.bottomAnchor, constant: 16.scale)
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
private extension ProfileEditFocusZoneView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.bold(size: 24.scale))
            .lineHeight(28.8.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.FocusZone.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFocusZoneButton(name: String) -> OFocusZoneButton {
        let view = OFocusZoneButton(name: name)
        view.layer.cornerRadius = 10.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(focusZoneTapped(sender:)), for: .touchUpInside)
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
