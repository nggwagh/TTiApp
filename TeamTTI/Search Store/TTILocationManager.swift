//
//  TTILocationManager.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 13/01/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit
import MapKit

class TTILocationManager: NSObject {

    let locationManager = CLLocationManager()
    static let sharedLocationManager = TTILocationManager()
    private var locationsToMonitor = [Store]()

    override init(){}
    
    func monitorRegions(regionsToMonitor : [Store])  {
        
        self.locationsToMonitor = regionsToMonitor
        
        for location in self.locationsToMonitor {
            
            let geofenceRegionCenter = CLLocationCoordinate2DMake(CLLocationDegrees((location.latitude?.doubleValue)!), CLLocationDegrees((location.longitude?.doubleValue)!))
            
            let identifier = String(location.name + "\(location.id)")
            let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter,
                                                  radius: 100,
                                                  identifier: identifier)
            
            geofenceRegion.notifyOnEntry = true
            geofenceRegion.notifyOnExit = true
            
            self.locationManager.startMonitoring(for: geofenceRegion)
        }
       
        self.locationManager.delegate = self
    }
}

extension TTILocationManager: CLLocationManagerDelegate {
    // called when user Exits a monitored region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            // Do what you want if this information
        }
    }
    
    // called when user Enters a monitored region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            // Do what you want if this information
        }
    }
}
