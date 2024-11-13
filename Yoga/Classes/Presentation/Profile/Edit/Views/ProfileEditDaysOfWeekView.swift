//
//  ProfileEditDaysOfWeekView.swift
//  Soccer
//
//  Created by Виталий Загороднов on 29.04.2023.
//

import UIKit

final class ProfileEditDaysOfWeekView: UIView {
    var didTapSave: ((WeekSchedule) -> Void)?

    lazy var titleLabel = makeTitleLabel()
    lazy var suButton = makeDayOfWeekButton(dayOfWeek: .su)
    lazy var moButton = makeDayOfWeekButton(dayOfWeek: .mo)
    lazy var tuButton = makeDayOfWeekButton(dayOfWeek: .tu)
    lazy var weButton = makeDayOfWeekButton(dayOfWeek: .we)
    lazy var thButton = makeDayOfWeekButton(dayOfWeek: .th)
    lazy var frButton = makeDayOfWeekButton(dayOfWeek: .fr)
    lazy var saButton = makeDayOfWeekButton(dayOfWeek: .sa)
    lazy var continueButton = makeContinueButton()
    
    init(weekSchedule: WeekSchedule?) {
        super.init(frame: .zero)
        
        makeConstraints()
        initialize(weekSchedule: weekSchedule)
        checkEnabled()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ProfileEditDaysOfWeekView {
    func initialize(weekSchedule: WeekSchedule?) {
        backgroundColor = Appearance.main100
        if let weekSchedule {
            suButton.marked = weekSchedule.su
            moButton.marked = weekSchedule.mo
            tuButton.marked = weekSchedule.tu
            weButton.marked = weekSchedule.we
            thButton.marked = weekSchedule.th
            frButton.marked = weekSchedule.fr
            saButton.marked = weekSchedule.sa
        }
    }
    
    @objc
    func nextTapped() {
        let weekSchedule = WeekSchedule(
            su: suButton.marked,
            mo: moButton.marked,
            tu: tuButton.marked,
            we: weButton.marked,
            th: thButton.marked,
            fr: frButton.marked,
            sa: saButton.marked)
        
        didTapSave?(weekSchedule)
    }
    
    @objc
    func tapped(sender: UIButton) {
        guard let dayOfWeekButton = sender as? ODayOfWeekButton else {
            return
        }
        
        dayOfWeekButton.marked.toggle()
        
        checkEnabled()
    }
    
    func checkEnabled() {
        let buttons = [
            suButton,
            moButton,
            tuButton,
            weButton,
            thButton,
            frButton,
            saButton
        ]
        let marked = buttons.contains(where: { $0.marked })
        continueButton.isHidden = !marked
    }
}

// MARK: Make constraints
private extension ProfileEditDaysOfWeekView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 120.scale : 52.scale),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            suButton.widthAnchor.constraint(equalToConstant: 50.scale),
            suButton.heightAnchor.constraint(equalToConstant: 50.scale),
            suButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 46.scale),
            suButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 187.scale : 187.scale)
        ])
        
        NSLayoutConstraint.activate([
            moButton.widthAnchor.constraint(equalToConstant: 50.scale),
            moButton.heightAnchor.constraint(equalToConstant: 50.scale),
            moButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 104.scale),
            moButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 187.scale : 187.scale)
        ])
        
        NSLayoutConstraint.activate([
            tuButton.widthAnchor.constraint(equalToConstant: 50.scale),
            tuButton.heightAnchor.constraint(equalToConstant: 50.scale),
            tuButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 162.scale),
            tuButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 187.scale : 187.scale)
        ])
        
        NSLayoutConstraint.activate([
            weButton.widthAnchor.constraint(equalToConstant: 50.scale),
            weButton.heightAnchor.constraint(equalToConstant: 50.scale),
            weButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 220.scale),
            weButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 187.scale : 187.scale)
        ])
        
        NSLayoutConstraint.activate([
            thButton.widthAnchor.constraint(equalToConstant: 50.scale),
            thButton.heightAnchor.constraint(equalToConstant: 50.scale),
            thButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 278.scale),
            thButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 187.scale : 187.scale)
        ])
        
        NSLayoutConstraint.activate([
            frButton.widthAnchor.constraint(equalToConstant: 50.scale),
            frButton.heightAnchor.constraint(equalToConstant: 50.scale),
            frButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 134.scale),
            frButton.topAnchor.constraint(equalTo: suButton.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            saButton.widthAnchor.constraint(equalToConstant: 50.scale),
            saButton.heightAnchor.constraint(equalToConstant: 50.scale),
            saButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 192.scale),
            saButton.topAnchor.constraint(equalTo: suButton.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 54.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -62.scale : -32.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ProfileEditDaysOfWeekView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.bold(size: 24.scale))
            .lineHeight(28.8.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.DaysOfWeek.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDayOfWeekButton(dayOfWeek: DayOfWeek) -> ODayOfWeekButton {
        let view = ODayOfWeekButton(dayOfWeek: dayOfWeek)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.semiBold(size: 16.scale))
        
        let view = UIButton()
        view.backgroundColor = Appearance.main300
        view.layer.cornerRadius = 28.scale
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
