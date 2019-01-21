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
                                                
                        self.handleLocationExit(storeDictionary: storeObj)
                        
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
                
                self.handleLocationEntered(storeDictionary: storeDict)

                //Store InTime for Region Indentifier
                storeArray.append(storeDict as AnyObject)
                
                UserDefaults.standard.set(storeArray, forKey: "storeArray")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    // API call to upload Rep InTime and outTime
    func handleLocationExit(storeDictionary: [String: Any]) {
        
        let storeID = storeDictionary["id"]
        let op = "exit"
        let timestamp = Date().timeIntervalSince1970
        let latitude = 47.1334
        let longitude = 32.4565
        let distance = 15
            
        self.setSpentTimeForStore(storeId: storeID as! Int, op: op, timeStamp: Int(timestamp), latitude: latitude, longitude: longitude, distance: distance)
    }
    
    func handleLocationEntered(storeDictionary: [String: Any]) {
        
        let storeID = storeDictionary["id"]
        let op = "entry"
        let timestamp = Date().timeIntervalSince1970
        let latitude = 47.1334
        let longitude = 32.4565
        let distance = 15
        
        self.setSpentTimeForStore(storeId: storeID as! Int, op: op, timeStamp: Int(timestamp), latitude: latitude, longitude: longitude, distance: distance)
    }
    
    func setSpentTimeForStore(storeId: Int, op: String, timeStamp: Int, latitude: Double, longitude: Double, distance: Int) {
        
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
                    print("unhandled status code\(response.statusCode)")
                    //TODO:- handle an invaild status code
                }
                
            case let .failure(error):
                print(error.localizedDescription) //MOYA error
            }
        }
    }
}
