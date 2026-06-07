//
//  OSkillLevelView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.02.2023.
//

import UIKit
import RxSwift

protocol OSkillLevelViewDelegate: AnyObject {
    func skillLevelViewDidSelect(skillLevel: SkillLevel)
}

final class OSkillLevelView: OSlideView {
    weak var mainDelegate: OSkillLevelViewDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var slider = makeSlider()
    lazy var continueButton = makeContinueButton()
    
    private lazy var levelViews = [OSkillLevelScoreView]()
    
    private lazy var contentManager = ContentManager()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSkillLevelView {
    func initialize() {
        backgroundColor = Appearance.main100
        
        contentManager
            .obtainLevels(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
            .drive(Binder(self) { base, levels in
                base.createLevelViews(at: levels)
                base.slider.maximumValue = Float(levels.count)
                base.update(sender: base.slider)
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func update(sender: UISlider) {
        let value = round(sender.value)
        sender.value = value
        
        levelViews.enumerated().forEach { index, levelView in
            let levelValue = Float(index + 1)
            
            levelView.marked = (value >= levelValue, value == levelValue)
        }
    }
    
    @objc
    func nextTapped() {
        guard let level = levelViews.last(where: { $0.marked.1 })?.level else {
            return
        }
        
        mainDelegate?.skillLevelViewDidSelect(skillLevel: level)
        
        onNext()
    }
    
    func createLevelViews(at levels: [SkillLevel]) {
        levelViews.forEach { $0.removeFromSuperview() }
        levelViews = []
        
        let padding = 8.scale
        let totalPadding = CGFloat(levels.count - 1) * padding
        let totalWidth = UIScreen.main.bounds.width - 132.scale - totalPadding
        
        let levelWidth = totalWidth / CGFloat(levels.count)
        
        var x = 66.scale
        var height = 121.scale
        
        levels.forEach { level in
            let view = OSkillLevelScoreView(level: level)
            view.layer.masksToBounds = false
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: x),
                view.widthAnchor.constraint(equalToConstant: levelWidth),
                view.heightAnchor.constraint(equalToConstant: height),
                view.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -29.scale)
            ])
            
            x += levelWidth + padding
            height += 35.scale
            
            levelViews.append(view)
        }
    }
}

// MARK: Make constraints
private extension OSkillLevelView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 120.scale : 52.scale),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 38.scale),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -38.scale),
            slider.heightAnchor.constraint(equalToConstant: 20.scale),
            slider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 363.scale : 363.scale)
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
private extension OSkillLevelView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.bold(size: 24.scale))
            .lineHeight(28.8.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.SkillLevel.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeScoreView(level: SkillLevel) -> OSkillLevelScoreView {
        let view = OSkillLevelScoreView(level: level)
        view.backgroundColor = UIColor.clear
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSlider() -> UISlider {
        let view = UISlider()
        view.minimumValue = 1
        view.thumbTintColor = Appearance.main400
        view.maximumTrackTintColor = Appearance.main200
        view.minimumTrackTintColor = Appearance.main400
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(update(sender:)), for: .valueChanged)
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
