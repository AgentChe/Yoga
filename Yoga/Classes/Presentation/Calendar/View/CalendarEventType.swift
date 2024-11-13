//
//  CalendarEventType.swift
//  Soccer
//
//  Created by Виталий Загороднов on 23.04.2023.
//

import UIKit

final class CalendarEventType: UIView {
    lazy var titleLabel = makeLabel()
    lazy var statusView = makeStatusView()
    
    private lazy var statusViewWidth = NSLayoutConstraint()
    
    private lazy var attrs = TextAttributes()
        .font(Fonts.Inter.regular(size: 14.scale))
        .lineHeight(19.scale)
        .textColor(Appearance.mono100)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CalendarEventType {
    func setup(status: PlanStatus) {
        switch status {
        case .skipped:
            titleLabel.attributedText = "Calendar.Unfinished".localized.attributed(with: attrs)
            statusView.backgroundColor = Appearance.main300
            statusViewWidth.constant = 15.scale
        case .planned:
            titleLabel.attributedText = "Calendar.Scheduled".localized.attributed(with: attrs)
            statusView.backgroundColor = Appearance.main400
            statusViewWidth.constant = 6.scale
        case .completed:
            titleLabel.attributedText = "Calendar.Completed".localized.attributed(with: attrs)
            statusView.backgroundColor = Appearance.main500
            statusViewWidth.constant = 15.scale
        }
        statusViewWidth.isActive = true
    }
}

// MARK: Make constraints
private extension CalendarEventType {
    func makeConstraints() {
        statusViewWidth = statusView.widthAnchor.constraint(equalToConstant: 6.scale)
        NSLayoutConstraint.activate([
            statusViewWidth,
            statusView.leftAnchor.constraint(equalTo: leftAnchor),
            statusView.heightAnchor.constraint(equalToConstant: 6.scale),
            statusView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: statusView.rightAnchor, constant: 5.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CalendarEventType {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        addSubview(view)
        return view
    }
    
    func makeStatusView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 3.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
