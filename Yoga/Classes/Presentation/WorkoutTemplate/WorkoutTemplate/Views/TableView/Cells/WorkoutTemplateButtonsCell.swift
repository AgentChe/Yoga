//
//  WorkoutTemplateButtonsCell.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import UIKit

final class WorkoutTemplateButtonsCell: UITableViewCell {
    var didTapCalendar: (() -> Void)?
    var didTapStart: (() -> Void)?
    
    lazy var calendarButton = makeCalendarButton()
    lazy var calendarIconView = makeCalendarIconView()
    lazy var startButton = makeStartButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension WorkoutTemplateButtonsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func calendarTapped() {
        didTapCalendar?()
    }
    
    @objc
    func startTapped() {
        didTapStart?()
    }
}

// MARK: Make constraints
private extension WorkoutTemplateButtonsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            calendarButton.widthAnchor.constraint(equalToConstant: 54.scale),
            calendarButton.heightAnchor.constraint(equalToConstant: 54.scale),
            calendarButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            calendarButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            calendarIconView.widthAnchor.constraint(equalToConstant: 24.scale),
            calendarIconView.heightAnchor.constraint(equalToConstant: 24.scale),
            calendarIconView.centerXAnchor.constraint(equalTo: calendarButton.centerXAnchor),
            calendarIconView.centerYAnchor.constraint(equalTo: calendarButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            startButton.widthAnchor.constraint(equalToConstant: 273.scale),
            startButton.heightAnchor.constraint(equalToConstant: 54.scale),
            startButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 86.scale),
            startButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WorkoutTemplateButtonsCell {
    func makeCalendarButton() -> UIButton {
        let view = UIButton()
        view.layer.cornerRadius = 27.scale
        view.backgroundColor = Appearance.main200
        view.addTarget(self, action: #selector(calendarTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeCalendarIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "WorkoutTemplate.Calendar")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeStartButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(19.scale)
        
        let view = UIButton()
        view.setAttributedTitle("WorkoutTemplate.StartWorkout".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 28.scale
        view.backgroundColor = Appearance.main300
            view.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
