//
//  CalendarDateCell.swift
//  Soccer
//
//  Created by Виталий Загороднов on 21.04.2023.
//

import UIKit
import JTAppleCalendar

final class CalendarDateCell: JTACDayCell {
    lazy var daySelectView = makeDaySelectView()
    lazy var dayLabel = makeLabel()
    lazy var statusView = makeStatusView()
    
    private lazy var statusViewWidth = NSLayoutConstraint()
    
    private lazy var dayAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(25.6.scale)
        .textAlignment(.center)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CalendarDateCell {
    func setup(isSelected: Bool) {
        daySelectView.layer.borderWidth = isSelected ? 2.scale : 0
        daySelectView.layer.borderColor = isSelected ? Appearance.main400.cgColor : UIColor.clear.cgColor
    }
    
    func setup(isCurrentDay: Bool) {
        daySelectView.backgroundColor = isCurrentDay ? Appearance.main200 : UIColor.clear
    }
    
    func setup(status: PlanStatus?, text: String) {
        dayLabel.attributedText = text.attributed(with: dayAttrs)
        guard let status = status else {
            statusView.isHidden = true
            return
        }
        
        statusView.isHidden = false
        
        statusViewWidth.isActive = false
        switch status {
        case .skipped:
            statusView.backgroundColor = Appearance.main300
            statusViewWidth.constant = 15.scale
        case .planned:
            statusView.backgroundColor = Appearance.main400
            statusViewWidth.constant = 6.scale
        case .completed:
            statusView.backgroundColor = Appearance.main500
            statusViewWidth.constant = 15.scale
        }
        statusViewWidth.isActive = true
        layoutIfNeeded()
    }
}

// MARK: Make constraints
private extension CalendarDateCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            daySelectView.widthAnchor.constraint(equalToConstant: 40.scale),
            daySelectView.heightAnchor.constraint(equalToConstant: 40.scale),
            daySelectView.centerXAnchor.constraint(equalTo: dayLabel.centerXAnchor),
            daySelectView.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 7.scale)
        ])
        
        statusViewWidth = statusView.widthAnchor.constraint(equalToConstant: 6.scale)
        NSLayoutConstraint.activate([
            statusViewWidth,
            statusView.heightAnchor.constraint(equalToConstant: 6.scale),
            statusView.centerXAnchor.constraint(equalTo: centerXAnchor),
            statusView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.scale),
            statusView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 17.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CalendarDateCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDaySelectView() -> CircleView {
        let view = CircleView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeStatusView() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.layer.cornerRadius = 3.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    
}
