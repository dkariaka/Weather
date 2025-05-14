//
//  Date+Ext.swift
//  Weather
//
//  Created by Дмитрий К on 09.05.2025.
//

import Foundation

extension Date {
    func formattedHour(timezoneOffset: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        formatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        formatter.locale = Locale(identifier: "en_US_POSIX")

        return formatter.string(from: self)
    }
}
