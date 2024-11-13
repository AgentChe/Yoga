//
//  DailyPicksCollectionCell.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import UIKit
import Kingfisher

final class DailyPicksCollectionCell: UICollectionViewCell {
    lazy var pictureView = makeImageView()
    lazy var shadowView = makeShadowView()
    lazy var nameLabel = makeNameLabel()
    lazy var tag1Label = makeTagLabel()
    lazy var tag2Label = makeTagLabel()
    lazy var actionLabel = makeActionLabel()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Inter.semiBold(size: 20.scale))
        .lineHeight(24.scale)
        .textAlignment(.center)
    private lazy var tagAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Inter.semiBold(size: 12.scale))
        .lineHeight(14.4.scale)
        .textAlignment(.center)
    private lazy var actionAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Inter.semiBold(size: 16.scale))
        .lineHeight(19.2.scale)
        .textAlignment(.center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
extension DailyPicksCollectionCell {
    func setup(element: DailyPicksElement) {
        pictureView.kf.setImage(with: element.image)
        
        nameLabel.attributedText = element.name.attributed(with: nameAttrs)
        
        tag1Label.attributedText = element.tag1.attributed(with: tagAttrs)
        tag2Label.attributedText = element.tag2?.attributed(with: tagAttrs)
        
        tag2Label.isHidden = element.tag2 == nil
        
        actionLabel.attributedText = element.action.attributed(with: actionAttrs)
    }
}

// MARK: Private
private extension DailyPicksCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension DailyPicksCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            pictureView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pictureView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pictureView.topAnchor.constraint(equalTo: contentView.topAnchor),
            pictureView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 185.scale)
        ])
        
        NSLayoutConstraint.activate([
            tag1Label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            tag1Label.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            tag2Label.leadingAnchor.constraint(equalTo: tag1Label.trailingAnchor, constant: 10.scale),
            tag2Label.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            actionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            actionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension DailyPicksCollectionCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 8.scale
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeShadowView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 8.scale
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(integralRed: 9, green: 9, blue: 9, alpha: 0.5)
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
        view.backgroundColor = Appearance.mono200.withAlphaComponent(0.2)
        view.layer.cornerRadius = 11.scale
        view.layer.masksToBounds = true
        view.insets = UIEdgeInsets(top: 4.scale, left: 8.scale, bottom: 4.scale, right: 8.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeActionLabel() -> PaddingLabel {
        let view = PaddingLabel()
        view.backgroundColor = Appearance.main300
        view.layer.cornerRadius = 28.scale
        view.layer.masksToBounds = true
        view.insets = UIEdgeInsets(top: 16.scale, left: 46.scale, bottom: 16.scale, right: 46.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
