//
//  ProfileDetailsHeaderCell.swift
//  Soccer
//
//  Created by Виталий Загороднов on 29.04.2023.
//

import UIKit

final class ProfileDetailsHeaderCell: UITableViewCell {
    lazy var titleLabel = makeLabel()
    
    private lazy var attrs = TextAttributes()
        .font(Fonts.Inter.semiBold(size: 20.scale))
        .lineHeight(24.scale)
        .textColor(Appearance.mono100)
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

extension ProfileDetailsHeaderCell {
    func setup(title: String) {
        titleLabel.attributedText = title.attributed(with: attrs)
    }
}

// MARK: Private
private extension ProfileDetailsHeaderCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ProfileDetailsHeaderCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 33.scale),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.scale),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ProfileDetailsHeaderCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

