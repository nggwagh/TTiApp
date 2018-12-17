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
}

extension DateFormatter {
    static let formatter_yyyyMMdd: DateFormatter = .create(with: .yyyyMMdd)
    static let formatter_yyyyMMdd_hhmmss: DateFormatter = .create(with: .yyyyMMdd_hhmmss)
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
