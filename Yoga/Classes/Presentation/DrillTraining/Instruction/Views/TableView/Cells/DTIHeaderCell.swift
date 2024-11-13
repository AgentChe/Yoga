//
//  DTIHeaderCell.swift
//  Soccer
//
//  Created by Андрей Чернышев on 09.02.2023.
//

import UIKit
import Kingfisher

final class DTIHeaderCell: UITableViewCell {
    lazy var pictureView = makeImageView()
    lazy var nameLabel = makeNameLabel()
    lazy var tag1Label = makeTagLabel()
    lazy var tag2Label = makeTagLabel()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Inter.bold(size: 24.scale))
        .lineHeight(28.8.scale)
        .textAlignment(.center)
        .lineBreakMode(.byTruncatingTail)
    private lazy var tagAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Inter.semiBold(size: 12.scale))
        .lineHeight(14.4.scale)
        .textAlignment(.center)
    
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
extension DTIHeaderCell {
    func setup(element: DTIHeaderElement) {
        pictureView.kf.setImage(with: element.image)
        
        nameLabel.attributedText = element.name.attributed(with: nameAttrs)
        tag1Label.attributedText = element.skillLevel.attributed(with: tagAttrs)
        tag2Label.attributedText = element.drillCategory.attributed(with: tagAttrs)
    }
}

// MARK: Private
private extension DTIHeaderCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension DTIHeaderCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            pictureView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pictureView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pictureView.topAnchor.constraint(equalTo: contentView.topAnchor),
            pictureView.heightAnchor.constraint(equalToConstant: 264.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            nameLabel.topAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            tag1Label.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -8.scale),
            tag1Label.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            tag2Label.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 8.scale),
            tag2Label.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension DTIHeaderCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTagLabel() -> PaddingLabel {
        let view = PaddingLabel()
        view.backgroundColor = Appearance.main200
        view.layer.cornerRadius = 11.scale
        view.layer.masksToBounds = true
        view.insets = UIEdgeInsets(top: 4.scale, left: 8.scale, bottom: 4.scale, right: 8.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
