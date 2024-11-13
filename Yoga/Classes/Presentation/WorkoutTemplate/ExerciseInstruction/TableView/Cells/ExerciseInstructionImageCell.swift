//
//  ExerciseInstructionImageCell.swift
//  Soccer
//
//  Created by Андрей Чернышев on 15.03.2023.
//

import UIKit
import Kingfisher

final class ExerciseInstructionImageCell: UITableViewCell {
    lazy var pictureView = makeImageView()
    
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
extension ExerciseInstructionImageCell {
    func setup(element: URL) {
        pictureView.kf.setImage(with: element)
    }
}

// MARK: Private
private extension ExerciseInstructionImageCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ExerciseInstructionImageCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            pictureView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30.scale),
            pictureView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30.scale),
            pictureView.topAnchor.constraint(equalTo: contentView.topAnchor),
            pictureView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ExerciseInstructionImageCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
