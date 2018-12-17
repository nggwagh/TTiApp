//
//  String+Validations.swift
//  TeamTTI
//
//  Created by Mayur Deshmukh on 04/11/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import Foundation

extension String {

    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
