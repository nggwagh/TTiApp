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
            
            let identifier = String(location.name + " " + "\(location.id)")
            let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter,
                                                  radius: 100,
                                                  identifier: identifier)
            
            //SAVE CLOSEST STORE ARRAY
            var closestStoreIdArray: [Int] = UserDefaults.standard.value(forKey: "closestStoreIdArray") as! [Int]
            closestStoreIdArray.append(location.id)
            UserDefaults.standard.set(closestStoreIdArray, forKey: "closestStoreIdArray")
            UserDefaults.standard.synchronize()
            
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
            let closestStoreIdArray: [Int] = UserDefaults.standard.value(forKey: "closestStoreIdArray") as! [Int]
            let identifier = region.identifier.components(separatedBy: " ")
            
            if closestStoreIdArray.contains(Int(identifier.last!)!) {
                
                var storeArray: [AnyObject] = UserDefaults.standard.value(forKey: "storeArray") as! [AnyObject]
                
                for i in (0..<storeArray.count) {
                    
                    var storeObj = storeArray[i] as! [String: Any]
                    
                    if (storeObj["id"] as! String) == identifier.last {
                        
                        storeObj["outtime"] = Date()
                        
                        self.uploadRepTimeToServer(storeDictionary: storeObj)
                        
                        //Remove after uploading In and Out time
                        storeArray.remove(at: i)
                        UserDefaults.standard.set(storeArray, forKey: "storeArray")
                        UserDefaults.standard.synchronize()
                    }
                }
            }
        }
    }
    
    
    // called when user Enters a monitored region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            // Do what you want if this information
            
            let closestStoreIdArray: [Int] = UserDefaults.standard.value(forKey: "closestStoreIdArray") as! [Int]
            let identifier = region.identifier.components(separatedBy: " ")
            
            if closestStoreIdArray.contains(Int(identifier.last!)!) {
                
                var storeArray: [AnyObject] = UserDefaults.standard.value(forKey: "storeArray") as! [AnyObject]
                
                var storeDict = [String: Any]()
                
                storeDict["id"] = identifier.last
                storeDict["intime"] = Date()
                storeDict["outtime"] = ""

                //Store InTime for Region Indentifier
                storeArray.append(storeDict as AnyObject)
                
                UserDefaults.standard.set(storeArray, forKey: "storeArray")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    // API call to upload Rep InTime and outTime
    func uploadRepTimeToServer(storeDictionary: [String: Any]) {
        
        
    }
}
