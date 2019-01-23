//
//  Extensions.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 23/01/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import Foundation

extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}
