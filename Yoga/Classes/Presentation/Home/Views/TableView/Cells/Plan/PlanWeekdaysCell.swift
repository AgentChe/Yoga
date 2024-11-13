//
//  PlanWeekdaysCell.swift
//  Soccer
//
//  Created by Андрей Чернышев on 11.03.2023.
//

import UIKit

final class PlanWeekdaysCell: UITableViewCell {
    var didTap: ((Date) -> Void)?
    
    lazy var weekdayButton1 = makeWeekdayButton()
    lazy var weekdayButton2 = makeWeekdayButton()
    lazy var weekdayButton3 = makeWeekdayButton()
    lazy var weekdayButton4 = makeWeekdayButton()
    lazy var weekdayButton5 = makeWeekdayButton()
    lazy var weekdayButton6 = makeWeekdayButton()
    lazy var weekdayButton7 = makeWeekdayButton()
    
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
extension PlanWeekdaysCell {
    func setup(element: [PlanWeekDayButton.Model]) {
        setup(model: element[safe: 0], in: weekdayButton1)
        setup(model: element[safe: 1], in: weekdayButton2)
        setup(model: element[safe: 2], in: weekdayButton3)
        setup(model: element[safe: 3], in: weekdayButton4)
        setup(model: element[safe: 4], in: weekdayButton5)
        setup(model: element[safe: 5], in: weekdayButton6)
        setup(model: element[safe: 6], in: weekdayButton7)
    }
}

// MARK: Private
private extension PlanWeekdaysCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    func setup(model: PlanWeekDayButton.Model?, in button: PlanWeekDayButton) {
        guard let model = model else {
            return
        }
        
        button.setup(model: model)
    }
    
    @objc
    func didTapButton(sender: UIButton) {
        guard let planButton = sender as? PlanWeekDayButton else {
            return
        }
        
        let date = planButton.model.day
        didTap?(date)
    }
}

// MARK: Make constraints
private extension PlanWeekdaysCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            weekdayButton1.widthAnchor.constraint(equalToConstant: 40.scale),
            weekdayButton1.heightAnchor.constraint(equalToConstant: 93.scale),
            weekdayButton1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18.scale),
            weekdayButton1.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weekdayButton2.widthAnchor.constraint(equalToConstant: 40.scale),
            weekdayButton2.heightAnchor.constraint(equalToConstant: 93.scale),
            weekdayButton2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 68.scale),
            weekdayButton2.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weekdayButton3.widthAnchor.constraint(equalToConstant: 40.scale),
            weekdayButton3.heightAnchor.constraint(equalToConstant: 93.scale),
            weekdayButton3.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 118.scale),
            weekdayButton3.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weekdayButton4.widthAnchor.constraint(equalToConstant: 40.scale),
            weekdayButton4.heightAnchor.constraint(equalToConstant: 93.scale),
            weekdayButton4.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 168.scale),
            weekdayButton4.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weekdayButton5.widthAnchor.constraint(equalToConstant: 40.scale),
            weekdayButton5.heightAnchor.constraint(equalToConstant: 93.scale),
            weekdayButton5.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 218.scale),
            weekdayButton5.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weekdayButton6.widthAnchor.constraint(equalToConstant: 40.scale),
            weekdayButton6.heightAnchor.constraint(equalToConstant: 93.scale),
            weekdayButton6.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 268.scale),
            weekdayButton6.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weekdayButton7.widthAnchor.constraint(equalToConstant: 40.scale),
            weekdayButton7.heightAnchor.constraint(equalToConstant: 93.scale),
            weekdayButton7.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 318.scale),
            weekdayButton7.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PlanWeekdaysCell {
    func makeWeekdayButton() -> PlanWeekDayButton {
        let view = PlanWeekDayButton()
        view.backgroundColor = UIColor.clear
        view.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
