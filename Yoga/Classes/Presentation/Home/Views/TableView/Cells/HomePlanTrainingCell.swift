//
//  HomePlanTrainingCell.swift
//  Soccer
//
//  Created by Андрей Чернышев on 11.03.2023.
//

import UIKit
import Kingfisher

final class HomePlanTrainingCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var pictureView = makeImageView()
    lazy var contentLabel = makeLabel()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Inter.semiBold(size: 16.scale))
        .lineHeight(20.8.scale)
        .textAlignment(.left)
    private lazy var skillLevelAttrs = TextAttributes()
        .textColor(Appearance.mono100.withAlphaComponent(0.5))
        .font(Fonts.Inter.regular(size: 14.scale))
        .lineHeight(18.2.scale)
        .textAlignment(.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pictureView.kf.cancelDownloadTask()
        pictureView.image = nil
    }
}

// MARK: Public
extension HomePlanTrainingCell {
    func setup(element: HomePlanTrainingElement) {
        let result = NSMutableAttributedString()
        
        switch element.training {
        case .drill(let drill):
            pictureView.kf.setImage(with: drill.image)
            
            result.append((drill.name + "\n").attributed(with: nameAttrs))
        case .workout(let workout):
            pictureView.kf.setImage(with: workout.image)
            
            result.append((workout.name + "\n").attributed(with: nameAttrs))
        }
        
        result.append(element.skillLevel.name.attributed(with: skillLevelAttrs))
        
        contentLabel.attributedText = result
    }
}

// MARK: Private
private extension HomePlanTrainingCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension HomePlanTrainingCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            pictureView.widthAnchor.constraint(equalToConstant: 90.scale),
            pictureView.heightAnchor.constraint(equalToConstant: 90.scale),
            pictureView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            pictureView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 122.scale),
            contentLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            contentLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension HomePlanTrainingCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main200
        view.layer.cornerRadius = 10.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.mono200.withAlphaComponent(0.1).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8.scale
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.mono200.withAlphaComponent(0.1).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
