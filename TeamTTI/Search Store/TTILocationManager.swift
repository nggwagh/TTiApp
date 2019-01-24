//
//  TTILocationManager.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 13/01/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit
import MapKit
import Moya

class TTILocationManager: NSObject {
    
    let locationManager = CLLocationManager()
    static let sharedLocationManager = TTILocationManager()
    private var locationsToMonitor = [Store]()
    private var storeNetworkTask: Cancellable?
    
    
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
            var closestStoresArray = [Int]()
            if let storeIdArray : [Int] =  UserDefaults.standard.value(forKey: "closestStoreIdArray") as? [Int] {
                closestStoresArray.append(contentsOf: storeIdArray)
            }
            if (!closestStoresArray.contains(location.id)){
                closestStoresArray.append(location.id)
            }
            UserDefaults.standard.set(closestStoresArray, forKey: "closestStoreIdArray")
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
                
                if var storeArray: [Int] = UserDefaults.standard.value(forKey: "storeArray") as? [Int] {
                    
                    for i in (0..<storeArray.count) {
                        
                        if storeArray.contains(Int(identifier.last!)!) {
                            
                            self.handleLocationExit(storeId: Int(identifier.last!)!)
                            
                            //Remove after uploading In and Out time
                            storeArray.remove(at: i)
                            UserDefaults.standard.set(storeArray, forKey: "storeArray")
                            UserDefaults.standard.synchronize()
                        }
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
                
                var monitoringStoreArray = [Int]()
                
                if let stores : [Int] =  UserDefaults.standard.value(forKey: "storeArray") as? [Int] {
                    monitoringStoreArray.append(contentsOf: stores)
                }
                
                //Store InTime for Region Indentifier
                monitoringStoreArray.append(Int(identifier.last!)!)
                
                self.handleLocationEntered(storeId: Int(identifier.last!)!)
                
                UserDefaults.standard.set(monitoringStoreArray, forKey: "storeArray")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    // API call to upload Rep InTime and outTime
    func handleLocationExit(storeId : Int) {
        
        let storeID = storeId
        let op = "exit"
        let timestamp = Date().timeIntervalSince1970
        let latitude = UserDefaults.standard.double(forKey: "CurrentLatitude")
        let longitude = UserDefaults.standard.double(forKey: "CurrentLongitude")
        let distance = 15
        
        self.setSpentTimeForStore(storeId: storeID, op: op, timeStamp: Int(timestamp), latitude: latitude.description, longitude: longitude.description, distance: distance)
    }
    
    func handleLocationEntered(storeId : Int) {
        
        let storeID = storeId
        let op = "enter"
        let timestamp = Date().timeIntervalSince1970
        let latitude = UserDefaults.standard.double(forKey: "CurrentLatitude")
        let longitude = UserDefaults.standard.double(forKey: "CurrentLongitude")
        let distance = 15
        
        self.setSpentTimeForStore(storeId: storeID, op: op, timeStamp: Int(timestamp), latitude: latitude.description, longitude: longitude.description, distance: distance)
    }
    
    func setSpentTimeForStore(storeId: Int, op: String, timeStamp: Int, latitude: String, longitude: String, distance: Int) {
        
        storeNetworkTask?.cancel()
        
        storeNetworkTask = MoyaProvider<StoreApi>(plugins: [AuthPlugin()]).request(.setStoreSpentTime(storeId: storeId, op: op, timeStamp: timeStamp, latitude: latitude, longitude: longitude, distance: distance)) { result in
            
            switch result {
            case let .success(response):
                if case 200..<400 = response.statusCode {
                    do {
                        let jsonDict =   try JSONSerialization.jsonObject(with: response.data, options: []) as! [[String: Any]]
                        print(jsonDict)
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                } else {
                    let responseString = String(data: response.data, encoding: String.Encoding.utf8)
                    print(responseString!)
                }
                
            case let .failure(error):
                print(error.localizedDescription) //MOYA error
            }
        }
    }
}
