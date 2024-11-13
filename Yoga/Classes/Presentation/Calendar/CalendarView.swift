//
//  CalendarView.swift
//  Soccer
//
//  Created by Виталий Загороднов on 21.04.2023.
//

import UIKit
import JTAppleCalendar

final class CalendarView: UIView {
    lazy var calendarCollection = makeCalendarCollection()
    lazy var preloader = makePreloader()
    lazy var addButton = makeAddButton()
    lazy var closeButton = makeCloseButton()
    lazy var dayOfWeakStack = makeStackView()
    lazy var separatorView = makeSeparateView()
    lazy var planStatusStack = makeStackView()
    lazy var titleLabel = makeTitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CalendarView {
    func initialize() {
        backgroundColor = Appearance.main100
        let planned = CalendarEventType()
        planned.setup(status: .planned)
        let completed = CalendarEventType()
        completed.setup(status: .completed)
        let skipped = CalendarEventType()
        skipped.setup(status: .skipped)
        planStatusStack.addArrangedSubview(planned)
        planStatusStack.addArrangedSubview(completed)
        planStatusStack.addArrangedSubview(skipped)
        
        dayOfWeakStack.distribution = .fillEqually
        planStatusStack.distribution = .equalSpacing
        
        let attr = TextAttributes()
            .font(Fonts.Inter.regular(size: 12.scale))
            .lineHeight(16.scale)
            .textColor(Appearance.mono100.withAlphaComponent(0.7))
            .textAlignment(.center)
        
        Calendar.current.veryShortStandaloneWeekdaySymbols
            .forEach {
                let label = UILabel()
                label.attributedText = $0.attributed(with: attr)
                dayOfWeakStack.addArrangedSubview(label)
            }
    }
}

// MARK: Make constraints
private extension CalendarView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 36.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 36.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 54.scale : 34.scale),
            closeButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dayOfWeakStack.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 9.scale),
            dayOfWeakStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 17.scale),
            dayOfWeakStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -17.scale),
            dayOfWeakStack.heightAnchor.constraint(equalToConstant: 45.scale)
        ])
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: dayOfWeakStack.bottomAnchor),
            separatorView.leftAnchor.constraint(equalTo: leftAnchor),
            separatorView.rightAnchor.constraint(equalTo: rightAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1.scale)
        ])
        
        NSLayoutConstraint.activate([
            calendarCollection.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16.scale),
            calendarCollection.leftAnchor.constraint(equalTo: leftAnchor, constant: 17.scale),
            calendarCollection.rightAnchor.constraint(equalTo: rightAnchor, constant: -17.scale)
        ])
        
        NSLayoutConstraint.activate([
            planStatusStack.topAnchor.constraint(equalTo: calendarCollection.bottomAnchor, constant: 16.scale),
            planStatusStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 38.scale),
            planStatusStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -38.scale),
        ])
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: planStatusStack.bottomAnchor, constant: 16.scale),
            addButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.scale),
            addButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.scale),
            addButton.heightAnchor.constraint(equalToConstant: 54.scale),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.leadingAnchor.constraint(equalTo: leadingAnchor),
            preloader.trailingAnchor.constraint(equalTo: trailingAnchor),
            preloader.topAnchor.constraint(equalTo: topAnchor),
            preloader.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CalendarView {
    func makeCalendarCollection() -> CalendarCollectionView {
        let view = CalendarCollectionView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> ScreenPreloader {
        let view = ScreenPreloader()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAddButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(19.scale)
        
        let view = UIButton()
        view.setAttributedTitle("Calendar.Add".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 28.scale
        view.backgroundColor = Appearance.main300
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.setImage(UIImage(named: "Calendar.Close"), for: .normal)
        addSubview(view)
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparateView() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main200
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 20.scale))
            .lineHeight(24.scale)
            .textColor(Appearance.mono100)
            .textAlignment(.center)
        view.attributedText = "Calendar.SelectDate".localized.attributed(with: attrs)
        addSubview(view)
        return view
    }
}
