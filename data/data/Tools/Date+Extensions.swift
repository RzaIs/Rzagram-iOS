//
//  Date+Extensions.swift
//  data
//
//  Created by Rza Ismayilov on 08.11.22.
//

extension Date {
    init(_ string: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        self = formatter.date(from: string) ?? Date()
    }
}
