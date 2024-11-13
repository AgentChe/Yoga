//
//  ExerciseInstructionInstructionCell.swift
//  Soccer
//
//  Created by Андрей Чернышев on 15.03.2023.
//

import UIKit

final class ExerciseInstructionInstructionCell: UITableViewCell {
    lazy var titleLabel = makeTitleLabel()
    lazy var instructionLabel = makeLabel()
    
    private lazy var instructionAttrs = TextAttributes()
        .textColor(Appearance.mono100.withAlphaComponent(0.8))
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(25.6.scale)
        .textAlignment(.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ExerciseInstructionInstructionCell {
    func setup(element: String) {
        instructionLabel.attributedText = element.attributed(with: instructionAttrs)
    }
}

// MARK: Private
private extension ExerciseInstructionInstructionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ExerciseInstructionInstructionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            instructionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30.scale),
            instructionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30.scale),
            instructionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36.scale),
            instructionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ExerciseInstructionInstructionCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semiBold(size: 20.scale))
            .lineHeight(24.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "ExerciseInstruction.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
