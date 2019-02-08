//
//  Extensions.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 23/01/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import Foundation
import MapKit

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

extension CLLocation {
    func distanceFromCurrentLocationInMiles(latitude: Double, longitude: Double) -> Double{
        let coordinate = CLLocation(latitude: latitude, longitude: longitude)
        var distanceInMeters = self.distance(from: coordinate) // result is in meters
        distanceInMeters = distanceInMeters / 1000 //result in kilometers
        return distanceInMeters
    }
}
