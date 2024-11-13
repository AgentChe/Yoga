//
//  PlanWeekDayButton.swift
//  Soccer
//
//  Created by Андрей Чернышев on 11.03.2023.
//

import UIKit

final class PlanWeekDayButton: UIButton {
    lazy var dayOfWeekLabel = makeLabel()
    lazy var daySelectView = makeDaySelectView()
    lazy var dayLabel = makeLabel()
    lazy var statusView = makeStatusView()
    
    var model: Model!
    
    private lazy var statusViewWidth = NSLayoutConstraint()
    
    private lazy var dayOfWeekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    private lazy var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()
    
    private lazy var dayOfWeekAttrs = TextAttributes()
        .textColor(Appearance.mono100.withAlphaComponent(0.7))
        .font(Fonts.Inter.regular(size: 12.scale))
        .lineHeight(16.8.scale)
        .textAlignment(.center)
    private lazy var dayOfWeekSelectedAttrs = TextAttributes()
        .textColor(Appearance.main400)
        .font(Fonts.Inter.regular(size: 12.scale))
        .lineHeight(16.8.scale)
        .textAlignment(.center)
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
extension PlanWeekDayButton {
    struct Model {
        let day: Date
        let isCurrentDay: Bool
        let isSelected: Bool
        let planStatus: PlanStatus?
    }
    
    func setup(model: Model) {
        self.model = model
        
        let dayOfWeekAttrs = model.isCurrentDay ? self.dayOfWeekSelectedAttrs : self.dayOfWeekAttrs
        dayOfWeekLabel.attributedText = dayOfWeekFormatter.string(from: model.day).attributed(with: dayOfWeekAttrs)
        
        dayLabel.attributedText = dayFormatter.string(from: model.day).attributed(with: dayAttrs)
        
        daySelectView.backgroundColor = model.isCurrentDay ? Appearance.main200 : UIColor.clear
        daySelectView.layer.borderWidth = model.isSelected ? 2.scale : 0
        daySelectView.layer.borderColor = model.isSelected ? Appearance.main400.cgColor : UIColor.clear.cgColor
        
        setup(status: model.planStatus)
    }
}

// MARK: Private
private extension PlanWeekDayButton {
    func setup(status: PlanStatus?) {
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
private extension PlanWeekDayButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            dayOfWeekLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dayOfWeekLabel.topAnchor.constraint(equalTo: topAnchor, constant: 9.5.scale)
        ])
        
        NSLayoutConstraint.activate([
            daySelectView.widthAnchor.constraint(equalToConstant: 40.scale),
            daySelectView.heightAnchor.constraint(equalToConstant: 40.scale),
            daySelectView.centerXAnchor.constraint(equalTo: dayLabel.centerXAnchor),
            daySelectView.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 44.scale)
        ])
        
        statusViewWidth = statusView.widthAnchor.constraint(equalToConstant: 6.scale)
        NSLayoutConstraint.activate([
            statusViewWidth,
            statusView.heightAnchor.constraint(equalToConstant: 6.scale),
            statusView.centerXAnchor.constraint(equalTo: centerXAnchor),
            statusView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PlanWeekDayButton {
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
