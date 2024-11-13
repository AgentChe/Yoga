//
//  HomeDrillCoverCell.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.02.2023.
//

import UIKit
import Kingfisher

final class HomeDrillCoverCell: UITableViewCell {
    lazy var pictureView = makeImageView()
    lazy var contentLabel = makeLabel()
    lazy var arrowView = makeArrowView()
    
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
extension HomeDrillCoverCell {
    func setup(element: HomeDrillElement) {
        pictureView.kf.setImage(with: element.drill.image)
        
        let result = NSMutableAttributedString()
        result.append((element.drill.name + "\n").attributed(with: nameAttrs))
        result.append(element.skillLevel.name.attributed(with: skillLevelAttrs))
        contentLabel.attributedText = result
    }
}

// MARK: Private
private extension HomeDrillCoverCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension HomeDrillCoverCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            pictureView.widthAnchor.constraint(equalToConstant: 90.scale),
            pictureView.heightAnchor.constraint(equalToConstant: 90.scale),
            pictureView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pictureView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 122.scale),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -56.scale),
            contentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            arrowView.widthAnchor.constraint(equalToConstant: 32.scale),
            arrowView.heightAnchor.constraint(equalToConstant: 32.scale),
            arrowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            arrowView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension HomeDrillCoverCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8.scale
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.mono200.withAlphaComponent(0.1).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeArrowView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Home.Arrow")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
