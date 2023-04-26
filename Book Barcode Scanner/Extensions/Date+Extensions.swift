//
//  DateFormatter+Extensions.swift
//  Book Barcode Scanner
//
//  Created by Robert Faist on 4/21/23.
//

import Foundation

extension Date {
    static func publishDate(from date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: date)
    }
    
    static func publishDateString(from date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
}
