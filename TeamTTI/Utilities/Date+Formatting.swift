//
//  Date+Formatting.swift
//  TeamTTI
//
//  Created by Mayur Deshmukh on 18/11/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import Foundation

struct DateFormats {
    static let yyyyMMdd_hhmmss = "yyyy-MM-dd hh:mm:ss"
    static let yyyyMMdd_HHmmss = "yyyy-MM-dd HH:mm:ss"
    static let yyyyMMdd = "yyyy-MM-dd"
    static let MMMddyyyy = "MMM dd, yyyy"
    static let MMMMddyyyy = "MMMM dd, yyyy"
    static let MMMM = "MMMM"
}

extension DateFormatter {
    static let formatter_yyyyMMdd: DateFormatter = .create(with: DateFormats.yyyyMMdd)
    static let formatter_yyyyMMdd_hhmmss: DateFormatter = .create(with: DateFormats.yyyyMMdd_hhmmss)
    static let formatter_MMMddyyyy: DateFormatter = .create(with: DateFormats.MMMddyyyy)
    static let formatter_MMMMddyyyy: DateFormatter = .create(with: DateFormats.MMMMddyyyy)

    static func create(with format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter
    }
}

extension DateFormatter {
    func parse(value: Any?) -> Date? {
        guard let value = value as? String else { return nil }
        return date(from: value)
    }
}


extension Date{
    static func convertDateString(inputDateFormat: String, outputDateFormat: String,  _ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputDateFormat
        let dateString = dateFormatter.date(from: date)
        dateFormatter.dateFormat = outputDateFormat
        return  dateFormatter.string(from: dateString!)
    }
    
    static func convertToDateFromString(inputDateFormat: String, outputDateFormat: String,  _ date: String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputDateFormat
        let date1 = dateFormatter.date(from: date)
        let dateString = dateFormatter.string(from: date1!)
        dateFormatter.dateFormat = outputDateFormat
        return  dateFormatter.date(from: dateString)!
    }
    
    static func convertDate(from inputDateFormat: String, to outputDateFormat: String,  _ date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputDateFormat
        dateFormatter.dateFormat = outputDateFormat
        return  dateFormatter.string(from: date)
    }
}
