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

extension UIAlertController {
    func createSettingsAlertController(title: String, message: String) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
     //   let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment:"" ), style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment:"" ), style: .default, handler: { action in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        })
      //  controller.addAction(cancelAction)
        controller.addAction(settingsAction)
        
        return controller
    }
}
