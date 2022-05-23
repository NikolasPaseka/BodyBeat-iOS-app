//
//  Date.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 23.05.2022.
//

import Foundation

extension Date: Strideable {
    
    public func distance(to other: Date) -> TimeInterval {
        return other.timeIntervalSinceReferenceDate - self.timeIntervalSinceReferenceDate
    }

    public func advanced(by n: TimeInterval) -> Date {
        return self + n
    }


//    enum Weekday: CaseIterable {
//        case sunday
//        case monday
//        case tuesday
//        case wednesday
//        case thursday
//        case friday
//        case saturday
//    }
//
//    var isWednesday: Bool { dayOfTheWeek == .wednesday } // 🐸
//
//    var dayOfTheWeek: Date.Weekday {
//        let dayNumber = Calendar.current.component(.weekday, from: self)
//        return Weekday.allCases[dayNumber - 1]
//    }
    
    func dayOfTheWeek(day: Date) -> String {
        let weekdays = [
            "sunday",
            "monday",
            "tuesday",
            "wednesday",
            "thursday",
            "friday",
            "saturday"
        ]

        //let calendar: NSCalendar = NSCalendar.currentCalendar()
        //let components: NSDateComponents = calendar.components(.Weekday, fromDate: self)
        let dayNumber = Calendar.current.component(.weekday, from: day)
        return weekdays[dayNumber - 1]
    }
}
