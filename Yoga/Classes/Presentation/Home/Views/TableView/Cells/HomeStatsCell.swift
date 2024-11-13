//
//  HomeStatsCell.swift
//  Soccer
//
//  Created by Андрей Чернышев on 10.03.2023.
//

import UIKit

final class HomeStatsCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var scoreValueLabel = makeLabel()
    lazy var scoreTitleLabel = makeScoreTitleLabel()
    lazy var levelLabel = makeLabel()
    
    private lazy var scoreValueAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Inter.semiBold(size: 20.scale))
        .lineHeight(24.scale)
    private lazy var levelAttrs = TextAttributes()
        .textColor(Appearance.mono100.withAlphaComponent(0.7))
        .font(Fonts.Inter.regular(size: 14.scale))
        .lineHeight(19.6.scale)
        .letterSpacing(0.14.scale)
    
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
extension HomeStatsCell {
    func setup(element: HomeStatsElement) {
        scoreValueLabel.attributedText = String(format: "%i%%", element.score).attributed(with: scoreValueAttrs)
        levelLabel.attributedText = String(format: "Home.Level".localized, element.skillLevel.name).attributed(with: levelAttrs)
    }
}

// MARK: Private
private extension HomeStatsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension HomeStatsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scoreValueLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            scoreValueLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scoreTitleLabel.leadingAnchor.constraint(equalTo: scoreValueLabel.trailingAnchor, constant: 12.scale),
            scoreTitleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            levelLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            levelLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension HomeStatsCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 8.scale
        view.backgroundColor = Appearance.main200
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeScoreTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(25.6.scale)
        
        let view = UILabel()
        view.attributedText = "Home.YourScore".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
