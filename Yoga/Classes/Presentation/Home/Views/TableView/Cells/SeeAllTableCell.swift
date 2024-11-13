//
//  SeeAllTableCell.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import UIKit

final class SeeAllTableCell: UITableViewCell {
    lazy var nameLabel = makeLabel()
    lazy var seeAllLabel = makeSeeAllLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Inter.semiBold(size: 20.scale))
        .lineHeight(24.scale)
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
extension SeeAllTableCell {
    func setup(element: String) {
        nameLabel.attributedText = element.attributed(with: attrs)
    }
}

// MARK: Private
private extension SeeAllTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SeeAllTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            seeAllLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            seeAllLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SeeAllTableCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSeeAllLabel() -> PaddingLabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semiBold(size: 12.scale))
            .lineHeight(14.4.scale)
            .textAlignment(.center)
        
        let view = PaddingLabel()
        view.insets = UIEdgeInsets(top: 8.scale, left: 12.scale, bottom: 8.scale, right: 12.scale)
        view.backgroundColor = Appearance.main200
        view.layer.cornerRadius = 6.scale
        view.layer.masksToBounds = true
        view.attributedText = "Home.SeeAll".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
