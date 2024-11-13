//
//  ProfileCalendarView.swift
//  Soccer
//
//  Created by Виталий Загороднов on 26.04.2023.
//

import UIKit
import JTAppleCalendar

final class ProfileCalendarView: JTACMonthView {
    private var didSelectDate: ((Date) -> Void)?
    private var elements = [PlanOnDay]()

    override init() {
        super.init()
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ProfileCalendarView {
    func setup(elements: [PlanOnDay], didSelectDate: @escaping (Date) -> Void) {
        self.elements = elements
        self.didSelectDate = didSelectDate
        reloadData()
    }
}

// MARK: JTACMonthViewDataSource
extension ProfileCalendarView: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let startDate = calendar.date(byAdding: .year, value: -2, to: currentDate) ?? currentDate
        let endDate = calendar.date(byAdding: .year, value: 2, to: currentDate) ?? currentDate
        
        return ConfigurationParameters(
            startDate: startDate,
            endDate: endDate,
            numberOfRows: 1,
            firstDayOfWeek: .sunday
        )
    }
}

// MARK: JTACMonthViewDelegate
extension ProfileCalendarView: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: String(describing: ProfileCalendarDayCell.self), for: indexPath) as! ProfileCalendarDayCell
        configureCell(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? ProfileCalendarDayCell else { return }
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? ProfileCalendarDayCell else { return }
        cell.setup(isSelected: cellState.isSelected)
        didSelectDate?(date)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? ProfileCalendarDayCell else { return }
        cell.setup(isSelected: cellState.isSelected)
    }
}

// MARK: Private
private extension ProfileCalendarView {
    func initialize() {
        scrollDirection = .horizontal
        calendarDelegate = self
        calendarDataSource = self
        backgroundColor = .clear
        scrollingMode = .stopAtEachCalendarFrame
        register(ProfileCalendarDayCell.self, forCellWithReuseIdentifier: String(describing: ProfileCalendarDayCell.self))
    }
    
    func configureCell(cell: ProfileCalendarDayCell, cellState: CellState) {
        let calendar = Calendar.current
        let status = elements.first(where: { calendar.compare($0.day, to: cellState.date, toGranularity: .day) == .orderedSame })?.status
        
        cell.setup(isCurrentDay: calendar.compare(cellState.date, to: Date(), toGranularity: .day) == .orderedSame)
        cell.setup(status: status, text: cellState.text, weekDay: cellState.day)
        cell.setup(isSelected: cellState.isSelected)
    }
}
