//
//  DrillTrainingInstructionScrollView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import UIKit

final class DrillTrainingInstructionScrollView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var closeButton = makeCloseButton()
    lazy var scrollView = makeScrollView()
    lazy var instructionLabel = makeInstructionLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono100.withAlphaComponent(0.8))
        .font(Fonts.Inter.regular(size: 14.scale))
        .lineHeight(19.6.scale)
        .letterSpacing(0.14.scale)
        .textAlignment(.left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension DrillTrainingInstructionScrollView {
    func setup(instruction: String) {
        instructionLabel.attributedText = instruction.attributed(with: attrs)
    }
}

// MARK: Make constraints
private extension DrillTrainingInstructionScrollView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 30.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 32.scale),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -28.scale)
        ])
        
        NSLayoutConstraint.activate([
            instructionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scale),
            instructionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scale),
            instructionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 30.scale),
            instructionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -30.scale),
            instructionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            instructionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension DrillTrainingInstructionScrollView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(19.2.scale)
        
        let view = UILabel()
        view.attributedText = "DrillTraining.Instruction".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "DrillTraining.Close 1"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeInstructionLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
}
