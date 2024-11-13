//
//  Date+Extension.swift
//  Soccer
//
//  Created by Андрей Чернышев on 11.03.2023.
//

import Foundation

extension Date {
    func isEqualByDays(with date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.dateComponents([.day, .weekday, .year, .month], from: self) == calendar.dateComponents([.day, .weekday, .year, .month], from: date)
    }
}
