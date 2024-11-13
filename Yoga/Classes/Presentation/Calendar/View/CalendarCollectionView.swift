//
//  CalendarCollectionView.swift
//  Soccer
//
//  Created by Виталий Загороднов on 23.04.2023.
//

import UIKit
import JTAppleCalendar
import RxSwift
import RxCocoa

class CalendarCollectionView: JTACMonthView {
    private var elements: [PlanOnDay] = []
    private lazy var selectedDateRelay = BehaviorRelay<Date?>(value: nil)

    override init() {
        super.init()
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalendarCollectionView {
    func setup(elements: [PlanOnDay]) {
        self.elements = elements
        reloadData()
    }
    
    var selectedDate: Observable<Date> {
        selectedDateRelay.compactMap { $0 }.asObservable()
    }
}

extension CalendarCollectionView: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let startDate = calendar.date(byAdding: .year, value: -2, to: currentDate) ?? currentDate
        let endDate = calendar.date(byAdding: .year, value: 2, to: currentDate) ?? currentDate
        
        return ConfigurationParameters(
            startDate: startDate,
            endDate: endDate,
            firstDayOfWeek: .sunday
        )
    }
}

extension CalendarCollectionView: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: String(describing: CalendarDateCell.self), for: indexPath) as! CalendarDateCell
        configureCell(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarDateCell else { return }
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarDateCell else {
            return
        }
        
        cell.setup(isSelected: cellState.isSelected)
        
        let offset = TimeZone.current.secondsFromGMT(for: date)
        let selectedDate = Calendar.current.date(byAdding: .second, value: offset, to: date)
        
        selectedDateRelay.accept(selectedDate)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarDateCell else { return }
        cell.setup(isSelected: cellState.isSelected)
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: String(describing: CalendarMonthHeader.self), for: indexPath) as! CalendarMonthHeader
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        
        header.setup(title: formatter.string(from: range.start).capitalized)
        
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return .init(defaultSize: 41.scale)
    }
}

private extension CalendarCollectionView {
    func initialize() {
        scrollDirection = .vertical
        scrollingMode = .none
        cellSize = 56.scale
        calendarDataSource = self
        calendarDelegate = self
        allowsMultipleSelection = false
        register(CalendarDateCell.self, forCellWithReuseIdentifier: String(describing: CalendarDateCell.self))
        register(CalendarMonthHeader.self, forSupplementaryViewOfKind: "", withReuseIdentifier: String(describing: CalendarMonthHeader.self))
    }
    
    func configureCell(cell: CalendarDateCell, cellState: CellState) {
        let calendar = Calendar.current
        let status = elements.first(where: { calendar.compare($0.day, to: cellState.date, toGranularity: .day) == .orderedSame })?.status
        
        cell.isHidden = cellState.dateBelongsTo != .thisMonth
        cell.setup(isCurrentDay: calendar.compare(cellState.date, to: Date(), toGranularity: .day) == .orderedSame)
        cell.setup(status: status, text: cellState.text)
        cell.setup(isSelected: cellState.isSelected)
    }
}
