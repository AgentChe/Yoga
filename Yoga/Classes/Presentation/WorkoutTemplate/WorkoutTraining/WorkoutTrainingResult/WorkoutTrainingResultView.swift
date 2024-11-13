//
//  WorkoutTrainingResultView.swift
//  Soccer
//
//  Created by Виталий Загороднов on 13.04.2023.
//

import UIKit
import Kingfisher

class WorkoutTrainingResultView: UIView {
    lazy var closeButton = makeCloseButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var drillContainer = makeDrillContainer()
    lazy var imageView = makeImageView()
    lazy var nameLabel = makeNameLabel()
    lazy var skillLevelLabel = makeTagLabel()
    lazy var exerciseCountLabel = makeTagLabel()
    lazy var durationTitleLabel = makeDurationTitleLabel()
    lazy var durationLabel = makeDurationLabel()
    lazy var continueButton = makeContinueButton()
    
    private lazy var tagAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Inter.semiBold(size: 12.scale))
        .lineHeight(14.4.scale)
        .textAlignment(.center)
    
    private let workoutTraining: WorkoutTraining
    
    init(workoutTraining: WorkoutTraining) {
        self.workoutTraining = workoutTraining
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
extension WorkoutTrainingResultView {
    func setup(skillLevel: SkillLevel) {
        skillLevelLabel.attributedText = skillLevel.name.attributed(with: tagAttrs)
    }
}

// MARK: Private
private extension WorkoutTrainingResultView {
    func initialize() {
        backgroundColor = Appearance.main100
        
        let exerciseCount = String(format: "WorkoutTrainingResult.ExercisesCount".localized, workoutTraining.template.exercises.count)
        exerciseCountLabel.attributedText = exerciseCount.attributed(with: tagAttrs)
    }
}

// MARK: Make constraints
private extension WorkoutTrainingResultView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 60.scale : 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            drillContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            drillContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            drillContainer.heightAnchor.constraint(equalToConstant: 377.scale),
            drillContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 34.scale : 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 237.scale),
            imageView.heightAnchor.constraint(equalToConstant: 254.scale),
            imageView.centerXAnchor.constraint(equalTo: drillContainer.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: drillContainer.topAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: drillContainer.leadingAnchor, constant: 16.scale),
            nameLabel.trailingAnchor.constraint(equalTo: drillContainer.trailingAnchor, constant: -16.scale),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            skillLevelLabel.trailingAnchor.constraint(equalTo: drillContainer.centerXAnchor, constant: -8.scale),
            skillLevelLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            exerciseCountLabel.leadingAnchor.constraint(equalTo: drillContainer.centerXAnchor, constant: 8.scale),
            exerciseCountLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            durationTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            durationTitleLabel.topAnchor.constraint(equalTo: drillContainer.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            durationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            durationLabel.topAnchor.constraint(equalTo: durationTitleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 54.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WorkoutTrainingResultView {
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "WorkoutTrainingResult.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(19.2.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "WorkoutTrainingResult.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDrillContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono200
        view.layer.cornerRadius = 10.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.main200.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.kf.setImage(with: workoutTraining.template.image)
        view.translatesAutoresizingMaskIntoConstraints = false
        drillContainer.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semiBold(size: 20.scale))
            .lineHeight(24.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = workoutTraining.template.name.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        drillContainer.addSubview(view)
        return view
    }
    
    func makeTagLabel() -> PaddingLabel {
        let view = PaddingLabel()
        view.backgroundColor = Appearance.main200
        view.layer.cornerRadius = 11.scale
        view.layer.masksToBounds = true
        view.insets = UIEdgeInsets(top: 4.scale, left: 8.scale, bottom: 4.scale, right: 8.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        drillContainer.addSubview(view)
        return view
    }
    
    func makeDurationTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(19.2.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "DrillTrainingResult.Duration".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDurationLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.main300)
            .font(Fonts.Inter.bold(size: 32.scale))
            .lineHeight(38.4.scale)
            .textAlignment(.center)
        
        let seconds = workoutTraining.assignedWorkout.trainedTime
        var mins = 0
        var secs = seconds
        if seconds >= 60 {
            mins = Int(seconds / 60)
            secs = seconds - (mins * 60)
        }
        let string = String(format: "%02d:%02d", mins, secs)
        
        let view = UILabel()
        view.attributedText = string.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.semiBold(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 28.scale
        view.backgroundColor = Appearance.main300
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

