//
//  ProfileCalendarCell.swift
//  Soccer
//
//  Created by Виталий Загороднов on 25.04.2023.
//

import UIKit

class ProfileCalendarCell: UITableViewCell {
    
    lazy var calendarView = makeCalendarView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileCalendarCell {
    func setup(elements: [PlanOnDay], didSelectDate: @escaping (Date) -> Void) {
        calendarView.setup(elements: elements, didSelectDate: didSelectDate)
    }
}

// MARK: Private
private extension ProfileCalendarCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
        
        calendarView.scrollToDate(.init(), animateScroll: false) { [weak self] in
            
            guard let self = self else { return }
            
            self.calendarView.selectDates([.init()])
            
            if let today = self.calendarView.indexPathsForSelectedItems?.first {
                
                self.calendarView.scrollToItem(at: today, at: .centeredVertically, animated: false)
            }
        }
    }
}

// MARK: Make constraints
private extension ProfileCalendarCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: contentView.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            calendarView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 18.scale),
            calendarView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -18.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ProfileCalendarCell {
    func makeCalendarView() -> ProfileCalendarView {
        let view = ProfileCalendarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
