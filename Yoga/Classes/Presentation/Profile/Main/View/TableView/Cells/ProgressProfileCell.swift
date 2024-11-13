//
//  ProgressProfileCell.swift
//  Soccer
//
//  Created by Виталий Загороднов on 27.04.2023.
//

import UIKit

final class ProgressProfileCell: UITableViewCell {
    lazy var titleLabel = makeLabel()
    lazy var progressView = makeProgressView()
    
    private lazy var titleAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Inter.semiBold(size: 20.scale))
        .lineHeight(24.scale)
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
extension ProgressProfileCell {
    func setup(percent: Int, level: String) {
        progressView.setup(percent: percent)
        titleLabel.attributedText = String(format: "Profile.Level".localized, level).attributed(with: titleAttrs)
    }
}

// MARK: Private
private extension ProgressProfileCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ProgressProfileCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            progressView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ProgressProfileCell {
    func makeProgressView() -> ProfileMainProgressView {
        let view = ProfileMainProgressView()
        view.backgroundColor = UIColor.clear
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
