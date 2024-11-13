//
//  ODrillsTableCell.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.02.2023.
//

import UIKit

final class ODrillsTableCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var label = makeLabel()
    lazy var checkedView = makeCheckedView()
    
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
extension ODrillsTableCell {
    func setup(element: ODrillsTableElement) {
        container.layer.borderColor = element.marked ? Appearance.main300.cgColor : UIColor.clear.cgColor
        
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(25.6.scale)
            .textAlignment(.center)
            .lineBreakMode(.byTruncatingTail)
        label.attributedText = element.drillCategory.name.attributed(with: attrs)
        
        checkedView.isHidden = !element.marked
    }
}

// MARK: Private
private extension ODrillsTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ODrillsTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 42.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -42.scale)
        ])
        
        NSLayoutConstraint.activate([
            checkedView.widthAnchor.constraint(equalToConstant: 24.scale),
            checkedView.heightAnchor.constraint(equalToConstant: 24.scale),
            checkedView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            checkedView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ODrillsTableCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main200
        view.layer.cornerRadius = 10.scale
        view.layer.borderWidth = 1.scale
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
    
    func makeCheckedView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Onboarding.Drills.Checked")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
