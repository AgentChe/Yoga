//
//  ProfileMainStatsCell.swift
//  Soccer
//
//  Created by Виталий Загороднов on 27.04.2023.
//

import UIKit

final class ProfileMainStatsCell: UITableViewCell {
    lazy var titlelabel = makeTitleLabel()
    lazy var timeLabel = makeLabel()
    lazy var timeDescriptionLabel = makeLabel()
    
    private lazy var timeAttrs = TextAttributes()
        .textColor(Appearance.main400)
        .font(Fonts.Inter.bold(size: 50.scale))
        .lineHeight(60.scale)
        .textAlignment(.center)
    private lazy var timeDescriptionAttrs = TextAttributes()
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(25.6.scale)
        .textColor(Appearance.mono100)
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
extension ProfileMainStatsCell {
    func setup(trainingCompletedSeconds: Int) {
        let minutesHours = (trainingCompletedSeconds / 3600, (trainingCompletedSeconds % 3600) / 60)
        let hours = minutesHours.0
        let minutes = minutesHours.1
        
        let description: String
        if hours > 1 {
            description = "Profile.StatsDescription.Hours".localized
        } else if hours == 1 {
            description = "Profile.StatsDescription.Hour".localized
        } else {
            description = "Profile.StatsDescription.Min".localized
        }
        timeDescriptionLabel.attributedText = description.attributed(with: timeDescriptionAttrs)
        
        let value = hours > 0 ? hours : minutes
        timeLabel.attributedText = String(value).attributed(with: timeAttrs)
    }
}

// MARK: Private
private extension ProfileMainStatsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ProfileMainStatsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titlelabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titlelabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titlelabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            timeLabel.topAnchor.constraint(equalTo: titlelabel.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            timeDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            timeDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            timeDescriptionLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 16.scale),
            timeDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ProfileMainStatsCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 20.scale))
            .lineHeight(24.scale)
            .textColor(Appearance.mono100)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Profile.StatsTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
