//
//  Date+Extension.swift
//  presenter
//
//  Created by Rza Ismayilov on 19.11.22.
//

import Foundation

extension Date {
    var publishDate: String {
        let interval = Date() - self
        if let days = interval.day, days < 1 {
            return self.formatted(date: .omitted, time: .shortened)
        } else if let days = interval.day, days < 3 {
            return self.formatted(date: .abbreviated, time: .shortened)
        } else {
            return self.formatted(date: .abbreviated, time: .omitted)
        }
        
    }
    
    static func - (recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
}
