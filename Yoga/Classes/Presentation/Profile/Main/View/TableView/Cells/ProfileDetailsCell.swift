//
//  ProfileDetailsCell.swift
//  Soccer
//
//  Created by Виталий Загороднов on 25.04.2023.
//

import UIKit

final class ProfileDetailsCell: UITableViewCell {
    lazy var iconView = makeIconView()
    lazy var titleLabel = makeTitle()
    lazy var chevroneView = makeChevron()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ProfileDetailsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ProfileDetailsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 40.scale),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            chevroneView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            chevroneView.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 16.scale),
            chevroneView.heightAnchor.constraint(equalToConstant: 24.scale),
            chevroneView.widthAnchor.constraint(equalTo: chevroneView.heightAnchor),
            chevroneView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ProfileDetailsCell {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Profile.Profile")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitle() -> UILabel {
        let view = UILabel()
        let attrs = TextAttributes()
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(25.scale)
            .textColor(Appearance.mono100)
            .textAlignment(.left)
        view.attributedText = "Profile.MyProfile".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeChevron() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Profile.ChevronRight")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
