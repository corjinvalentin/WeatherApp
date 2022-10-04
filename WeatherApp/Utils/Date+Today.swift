//
//  Date+Today.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/18/22.
//

import Foundation

extension Date {
    var dayAndTimeText: String {
        let timeText = formatted(date: .omitted, time: .shortened)
        if Locale.current.calendar.isDateInToday(self) {
            let timeFormat = NSLocalizedString("Today at %@", comment: "Today at time format string")
            return String(format: timeFormat, timeText)
        } else {
            let dateText = formatted(.dateTime.month(.abbreviated).day())
            let dateAndTimeFormat = NSLocalizedString("%@ at %@", comment: "Date and time format string")
            return String(format: dateAndTimeFormat, dateText, timeText)
        }
    }
    
    var dayText: String {
        if Locale.current.calendar.isDateInToday(self) {
            return NSLocalizedString("Today", comment: "Today due date description")
        } else {
            return formatted(.dateTime.month().day().weekday(.wide))
        }
    }
    var timeText: String {
        if self.timeIntervalSinceNow < 0 { // Nu inteleg ???????? Ar trebui sa fie < 3600
            return NSLocalizedString("Now", comment: "Now time description")
        } else {
            return formatted(date: .omitted, time: .shortened)
        }
    }
}
