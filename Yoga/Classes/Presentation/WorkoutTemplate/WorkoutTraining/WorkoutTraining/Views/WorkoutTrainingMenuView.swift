//
//  WorkoutTrainingMenuView.swift
//  Soccer
//
//  Created by Виталий Загороднов on 24.03.2023.
//

import UIKit

final class WorkoutTrainingMenuView: UIView {
    lazy var titleLabel = makeLabel()
    lazy var nameLabel = makeNameLabel()
    lazy var nextExerciseTitle = makeNextLabel()
    lazy var nextExerciseLabel = makeNextLabel()
    lazy var containerView = makeView()
    lazy var nextContainerView = makeView()
    lazy var playPauseButton = makePlayPauseButton()
    lazy var previosButton = makePreviosButton()
    lazy var nextButton = makeNextButton()
    lazy var instructionButton = makeInstructionButton()
    lazy var finishButton = makeFinishButton()
    
    private var currentAction: TapAction = .next
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WorkoutTrainingMenuView {
    func setup(current: WorkoutExercise, next: WorkoutExercise?) {
        titleLabel.numberOfLines = 2
        
        let titleAnimation = CATransition()
        titleAnimation.duration = 0.3
        titleAnimation.type = .fade
        
        let nextExerciseAnimation = CATransition()
        nextExerciseAnimation.duration = 0.2
        nextExerciseAnimation.type = .push
        nextExerciseAnimation.subtype = currentAction == .next ? .fromRight : .fromLeft
        nextExerciseAnimation.timingFunction = .init(name: .easeIn)

        nextContainerView.isHidden = false
        nextExerciseTitle.attributedText = "WorkoutTraining.Next".localized.attributed(with: .nextTitleAttrs)
        nextExerciseLabel.attributedText = next?.name.attributed(with: .nextSubtitleAttrs)
        nextExerciseTitle.layer.add(nextExerciseAnimation, forKey: nil)
        nextExerciseLabel.layer.add(nextExerciseAnimation, forKey: nil)
        
        titleLabel.attributedText = current.name.attributed(with: .titleAttrs)
        
        titleLabel.layer.add(titleAnimation, forKey: nil)
        nameLabel.setup(name: current.subTitle)
    }
}

// MARK: Private
private extension WorkoutTrainingMenuView {
    enum TapAction {
        case next
        case previos
    }
    
    @objc func tapNext() {
        currentAction = .next
    }
    
    @objc func tapPrevios() {
        currentAction = .previos
    }
}

// MARK: Make constraints
private extension WorkoutTrainingMenuView {
    func makeConstrains() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16.scale),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16.scale),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -159.scale),
            containerView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            previosButton.widthAnchor.constraint(equalToConstant: 60.scale),
            previosButton.heightAnchor.constraint(equalToConstant: 60.scale),
            previosButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            previosButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            previosButton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            playPauseButton.widthAnchor.constraint(equalToConstant: 100.scale),
            playPauseButton.heightAnchor.constraint(equalToConstant: 100.scale),
            playPauseButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            playPauseButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            playPauseButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: 60.scale),
            nextButton.heightAnchor.constraint(equalToConstant: 60.scale),
            nextButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 24.scale),
            nextButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            nextButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            finishButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            finishButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            finishButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60.scale),
            finishButton.heightAnchor.constraint(equalToConstant: 54.scale)
        ])
        
        NSLayoutConstraint.activate([
            instructionButton.heightAnchor.constraint(equalToConstant: 24.scale),
            instructionButton.widthAnchor.constraint(equalTo: instructionButton.heightAnchor),
            instructionButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -22.scale),
            instructionButton.centerYAnchor.constraint(equalTo: nextContainerView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nextContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -54.scale),
            nextContainerView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 16.scale),
            nextContainerView.rightAnchor.constraint(lessThanOrEqualTo: instructionButton.leftAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            nextExerciseTitle.topAnchor.constraint(equalTo: nextContainerView.topAnchor),
            nextExerciseTitle.leftAnchor.constraint(equalTo: nextContainerView.leftAnchor),
            nextExerciseTitle.rightAnchor.constraint(equalTo: nextContainerView.rightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            nextExerciseLabel.topAnchor.constraint(equalTo: nextExerciseTitle.bottomAnchor),
            nextExerciseLabel.leftAnchor.constraint(equalTo: nextContainerView.leftAnchor),
            nextExerciseLabel.rightAnchor.constraint(equalTo: nextContainerView.rightAnchor),
            nextExerciseLabel.bottomAnchor.constraint(equalTo: nextContainerView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WorkoutTrainingMenuView {
    func makeView() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
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
    
    func makeNextLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        nextContainerView.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> WorkoutNameLabelView {
        let view = WorkoutNameLabelView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }

    func makePlayPauseButton() -> DrillTrainingPlayPauseButton {
        let view = DrillTrainingPlayPauseButton()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeNextButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.backgroundColor = UIColor.clear
        view.setImage(UIImage(named: "WorkoutTraining.Next"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(tapNext), for: .touchUpInside)
        containerView.addSubview(view)
        return view
    }
    
    func makePreviosButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.backgroundColor = UIColor.clear
        view.setImage(UIImage(named: "WorkoutTraining.Previos"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(tapPrevios), for: .touchUpInside)
        containerView.addSubview(view)
        return view
    }
    
    func makeInstructionButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.backgroundColor = UIColor.clear
        view.setImage(UIImage(named: "WorkoutTraining.Info"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFinishButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(19.scale)
            .textAlignment(.center)
        
        let view = UIButton()
        view.setAttributedTitle("WorkoutTraining.FinishWorkout".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main300
        view.layer.cornerRadius = 28.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let titleAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Inter.semiBold(size: 24.scale))
        .lineHeight(28.scale)
        .textAlignment(.center)
    
    static let nextTitleAttrs = TextAttributes()
        .textColor(Appearance.mono100.withAlphaComponent(0.5))
        .font(Fonts.Inter.regular(size: 14.scale))
        .lineHeight(20.scale)
        .textAlignment(.center)
    
    static let nextSubtitleAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Inter.semiBold(size: 16.scale))
        .lineHeight(20.scale)
        .textAlignment(.center)
}
