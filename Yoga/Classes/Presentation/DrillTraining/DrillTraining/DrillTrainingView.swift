//
//  DrillTrainingView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import UIKit

final class DrillTrainingView: UIView {
    lazy var imageView = makeImageView()
    lazy var closeButton = makeCloseButton()
    lazy var trainingTickLabel = makeLabel()
    lazy var pausedLabel = makePausedLabel()
    lazy var prepareLabel = makeLabel()
    lazy var menuView = makeMenuView()
    lazy var instructionView = makeInstructionView()
    lazy var preloader = makePreloader()
    
    private lazy var trainingTickAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Inter.semiBold(size: 20.scale))
        .lineHeight(24.scale)
        .textAlignment(.center)
    private lazy var prepareTickAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Inter.semiBold(size: 50.scale))
        .lineHeight(60.scale)
        .textAlignment(.center)
    private lazy var preparedAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Inter.bold(size: 60.scale))
        .lineHeight(70.scale)
        .textAlignment(.center)
    
    private lazy var menuBottomConstraint = NSLayoutConstraint()
    private lazy var instructionBottomConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension DrillTrainingView {
    func setup(drill: Drill) {
        imageView.setup(image: drill.image)
        menuView.setup(name: drill.name)
        instructionView.setup(instruction: drill.instruction)
    }
    
    func setup(trainingTick: String) {
        trainingTickLabel.attributedText = trainingTick.attributed(with: trainingTickAttrs)
    }
    
    func setup(prepareTick: String) {
        prepareLabel.attributedText = prepareTick.attributed(with: prepareTickAttrs)
    }
    
    func setup(prepared: String) {
        prepareLabel.attributedText = prepared.attributed(with: preparedAttrs)
    }
    
    func menu(hidden: Bool, animated: Bool = true, completion: (() -> Void)? = nil) {
        menuBottomConstraint.isActive = false
        menuBottomConstraint.constant = hidden ? 289.scale : 0
        menuBottomConstraint.isActive = true
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.layoutIfNeeded()
            }, completion: { success in
                completion?()
            })
        } else {
            layoutIfNeeded()
            
            completion?()
        }
    }
    
    func instruction(hidden: Bool, animated: Bool = true, completion: (() -> Void)? = nil) {
        instructionBottomConstraint.isActive = false
        instructionBottomConstraint.constant = hidden ? 364.scale : 0
        instructionBottomConstraint.isActive = true
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.layoutIfNeeded()
            }, completion: { success in
                completion?()
            })
        } else {
            layoutIfNeeded()
            
            completion?()
        }
    }
}

// MARK: Private
private extension DrillTrainingView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
}

// MARK: Make constraints
private extension DrillTrainingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 552.scale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 36.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 36.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 54.scale : 34.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            trainingTickLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            trainingTickLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 60.scale : 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            pausedLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            pausedLabel.topAnchor.constraint(equalTo: trainingTickLabel.bottomAnchor, constant: 9.scale)
        ])
        
        NSLayoutConstraint.activate([
            prepareLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            prepareLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        menuBottomConstraint = menuView.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([
            menuView.leadingAnchor.constraint(equalTo: leadingAnchor),
            menuView.trailingAnchor.constraint(equalTo: trailingAnchor),
            menuBottomConstraint,
            menuView.heightAnchor.constraint(equalToConstant: 289.scale)
        ])
        
        instructionBottomConstraint = instructionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([
            instructionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            instructionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            instructionBottomConstraint,
            instructionView.heightAnchor.constraint(equalToConstant: 364.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.leadingAnchor.constraint(equalTo: leadingAnchor),
            preloader.trailingAnchor.constraint(equalTo: trailingAnchor),
            preloader.topAnchor.constraint(equalTo: topAnchor),
            preloader.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension DrillTrainingView {
    func makeImageView() -> DrillTrainingBackgroundImageView {
        let view = DrillTrainingBackgroundImageView(frame: .zero)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "DrillTraining.Close"), for: .normal)
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
    
    func makePausedLabel() -> PaddingLabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.regular(size: 12.scale))
            .lineHeight(14.4.scale)
            .textAlignment(.center)
            .letterSpacing(-0.14.scale)
        
        let view = PaddingLabel()
        view.backgroundColor = Appearance.mono100.withAlphaComponent(0.2)
        view.layer.cornerRadius = 4.scale
        view.layer.masksToBounds = true
        view.insets = UIEdgeInsets(top: 4.scale, left: 8.scale, bottom: 4.scale, right: 8.scale)
        view.attributedText = "DrillTraining.Paused".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeMenuView() -> DrillTrainingMenuView {
        let view = DrillTrainingMenuView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeInstructionView() -> DrillTrainingInstructionScrollView {
        let view = DrillTrainingInstructionScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> ScreenPreloader {
        let view = ScreenPreloader()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
