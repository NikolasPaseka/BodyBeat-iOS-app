//
//  Date.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 23.05.2022.
//

import Foundation

extension Date: Strideable {
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: self)
    }
    
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    public func distance(to other: Date) -> TimeInterval {
        return other.timeIntervalSinceReferenceDate - self.timeIntervalSinceReferenceDate
    }

    public func advanced(by n: TimeInterval) -> Date {
        return self + n
    }
    
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
