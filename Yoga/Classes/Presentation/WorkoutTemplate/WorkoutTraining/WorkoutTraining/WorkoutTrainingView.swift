//
//  WorkoutTrainingView.swift
//  Soccer
//
//  Created by Виталий Загороднов on 23.03.2023.
//

import UIKit

final class WorkoutTrainingView: UIView {
    lazy var closeButton = makeCloseButton()
    lazy var instructionView = makeInstructionView()
    lazy var pausedLabel = makePausedLabel()
    lazy var menuView = makeMenuView()
    lazy var preloader = makePreloader()
    lazy var trainingTickLabel = makeLabel()
    lazy var prepareLabel = makeLabel()
    lazy var collectionView = makeCollectionView()
    lazy var progressView = makeProgressView()
    
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
    
    private lazy var menuYConstraint = NSLayoutConstraint()
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
extension WorkoutTrainingView {
    func setup(current: WorkoutExercise, next: WorkoutExercise?) {
        menuView.setup(current: current, next: next)
        instructionView.setup(instruction: current.instruction)
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
        menuYConstraint.isActive = false
        menuYConstraint = hidden ? menuView.topAnchor.constraint(equalTo: bottomAnchor) : menuView.bottomAnchor.constraint(equalTo: bottomAnchor)
        menuYConstraint.isActive = true
        
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
        progressView.isHidden = !hidden
        
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
private extension WorkoutTrainingView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
}

// MARK: Make constraints
private extension WorkoutTrainingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 552.scale)
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
        
        menuYConstraint = menuView.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([
            menuView.leadingAnchor.constraint(equalTo: leadingAnchor),
            menuView.trailingAnchor.constraint(equalTo: trailingAnchor),
            menuYConstraint
        ])
        
        NSLayoutConstraint.activate([
            progressView.leftAnchor.constraint(equalTo: leftAnchor),
            progressView.rightAnchor.constraint(equalTo: rightAnchor),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 10.scale)
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
private extension WorkoutTrainingView {
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "DrillTraining.Close"), for: .normal)
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
        view.attributedText = "WorkoutTraining.Paused".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeMenuView() -> WorkoutTrainingMenuView {
        let view = WorkoutTrainingMenuView()
        view.backgroundColor = UIColor.clear
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
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> WorkoutTrainingCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let view = WorkoutTrainingCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProgressView() -> ProgressSegmentView {
        let view = ProgressSegmentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 6.scale
        view.backgroundColor = Appearance.main200
        addSubview(view)
        return view
    }
}
