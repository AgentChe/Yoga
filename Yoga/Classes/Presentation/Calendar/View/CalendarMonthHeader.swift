//
//  CalendarMonthHeader.swift
//  Soccer
//
//  Created by Виталий Загороднов on 22.04.2023.
//

import UIKit
import JTAppleCalendar

final class CalendarMonthHeader: JTACMonthReusableView {
    lazy var monthLabel = makeLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Inter.semiBold(size: 20.scale))
        .lineHeight(24.scale)
        .textAlignment(.center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalendarMonthHeader {
    func setup(title: String) {
        monthLabel.attributedText = title.attributed(with: attrs)
    }
}

// MARK: Make constraints
private extension CalendarMonthHeader {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4.scale),
            monthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.scale),
            monthLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4.scale),
            monthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -4.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CalendarMonthHeader {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

