//
//  Date+Formatting.swift
//  TeamTTI
//
//  Created by Mayur Deshmukh on 18/11/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import Foundation

enum DateFormat: String {
    case yyyyMMdd_hhmmss = "yyyy-MM-dd hh:mm:ss"
    case yyyyMMdd = "yyyy-MM-dd"
    case MMMddyyyy = "MMM dd, yyyy"
    case MMMMddyyyy = "MMMM dd, yyyy"

}

extension DateFormatter {
    static let formatter_yyyyMMdd: DateFormatter = .create(with: .yyyyMMdd)
    static let formatter_yyyyMMdd_hhmmss: DateFormatter = .create(with: .yyyyMMdd_hhmmss)
    static let formatter_MMMddyyyy: DateFormatter = .create(with: .MMMddyyyy)
    static let formatter_MMMMddyyyy: DateFormatter = .create(with: .MMMMddyyyy)

}

extension DateFormatter {
    func parse(value: Any?) -> Date? {
        guard let value = value as? String else { return nil }
        return date(from: value)
    }
}

private extension DateFormatter {
    static func create(with format: DateFormat) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter
    } 
}

extension DateFormatter {
    static func convertDateStringToMMMddyyyy(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return  dateFormatter.string(from: date!)
    }
    
    static func convertDateToMMMMddyyyy(_ date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return  dateFormatter.string(from: date)
    }
    
}

