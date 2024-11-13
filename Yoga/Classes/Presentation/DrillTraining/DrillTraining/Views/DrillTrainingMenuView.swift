//
//  DrillTrainingMenuView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import UIKit

final class DrillTrainingMenuView: UIView {
    lazy var nameLabel = makeNameLabel()
    lazy var instructionButton = makeInstructionButton()
    lazy var playPauseButton = makePlayPauseButton()
    lazy var refreshButton = makeRefreshButton()
    lazy var finishButton = makeFinishButton()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Inter.semiBold(size: 24.scale))
        .lineHeight(28.8.scale)
        .textAlignment(.center)
        .lineBreakMode(.byTruncatingTail)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension DrillTrainingMenuView {
    func setup(name: String) {
        nameLabel.attributedText = name.attributed(with: nameAttrs)
    }
}

// MARK: Make constraints
private extension DrillTrainingMenuView {
    func makeConstrains() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            nameLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            instructionButton.widthAnchor.constraint(equalToConstant: 60.scale),
            instructionButton.heightAnchor.constraint(equalToConstant: 60.scale),
            instructionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 54.scale),
            instructionButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            playPauseButton.widthAnchor.constraint(equalToConstant: 100.scale),
            playPauseButton.heightAnchor.constraint(equalToConstant: 100.scale),
            playPauseButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playPauseButton.topAnchor.constraint(equalTo: topAnchor, constant: 45.scale)
        ])
        
        NSLayoutConstraint.activate([
            refreshButton.widthAnchor.constraint(equalToConstant: 60.scale),
            refreshButton.heightAnchor.constraint(equalToConstant: 60.scale),
            refreshButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 262.scale),
            refreshButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            finishButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            finishButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            finishButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60.scale),
            finishButton.heightAnchor.constraint(equalToConstant: 54.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension DrillTrainingMenuView {
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeInstructionButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.backgroundColor = UIColor.clear
        view.setImage(UIImage(named: "DrillTraining.Instruction"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePlayPauseButton() -> DrillTrainingPlayPauseButton {
        let view = DrillTrainingPlayPauseButton()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRefreshButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.backgroundColor = UIColor.clear
        view.setImage(UIImage(named: "DrillTraining.Refresh"), for: .normal)
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
        view.setAttributedTitle("DrillTraining.FinishTraining".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main300
        view.layer.cornerRadius = 28.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
