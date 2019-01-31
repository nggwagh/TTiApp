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
import UserNotifications

class TTILocationManager: NSObject {
    
    //MARK:- Instance Variables
    let locationManager = CLLocationManager()
    static let sharedLocationManager = TTILocationManager()
    private var locationsToMonitor = [Store]()
    private var storeNetworkTask: Cancellable?

    
    //MARK:- Instance Methods

    override init() {}
    
    func startUpdatingCurrentLocation() {
        // Ask for Authorisation from the User.
        locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
    }
    
    func monitorRegions(regionsToMonitor : [Store])  {
        
        self.locationsToMonitor = regionsToMonitor
        
        for location in self.locationsToMonitor {
            
            let geofenceRegionCenter = CLLocationCoordinate2DMake(CLLocationDegrees((location.latitude)!), CLLocationDegrees((location.longitude)!))
            
            let identifier = String(location.name + " " + "\(location.id)")
            let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter,
                                                  radius: 100,
                                                  identifier: identifier)
            
            //SAVE CLOSEST STORE ARRAY
            var closestStoresArray = [Int]()
            if let storeIdArray : [Int] =  UserDefaults.standard.value(forKey: "closestStoreIdArray") as? [Int] {
                closestStoresArray.append(contentsOf: storeIdArray)
            }

            
            if (!closestStoresArray.contains(location.id)) {
                
                closestStoresArray.append(location.id)
                
                UserDefaults.standard.set(closestStoresArray, forKey: "closestStoreIdArray")
                UserDefaults.standard.synchronize()
                
                geofenceRegion.notifyOnEntry = true
                geofenceRegion.notifyOnExit = true
                
                self.locationManager.startMonitoring(for: geofenceRegion)
            }
            
            //CODE TO CHECK AND REMOVE REGION MONITORING IF ITS NOT BELONGS TO CLOSED STORES THEN REMOVE REGION MONITORING
            self.checkIfClosestStoreNotAvailableThenStopMonitoring()
            
            //test code for api testing
            // self.dummyTestApi()
        }
    }
    
    //MARK:- Private methods
    
    /*
    //test code for api testing
    func dummyTestApi(){
        
        let closestStoreIdArray: [Int] = UserDefaults.standard.value(forKey: "closestStoreIdArray") as! [Int]
        
        if closestStoreIdArray.contains(1) {
            
            var inTimeDict = [String: Any]()
            
            inTimeDict["storeID"] = 1
            inTimeDict["op"] = "exit"
            inTimeDict["timestamp"] = 1324325464//Date().timeIntervalSince1970
            inTimeDict["latitude"] = String(format: "%f", (self.locationManager.location?.coordinate.latitude)!)
            inTimeDict["longitude"] = String(format: "%f", (self.locationManager.location?.coordinate.longitude)!)
            
            let currentCoordinate = CLLocation(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
            
            let storeRegion = self.locationsToMonitor.filter{ $0.id == 1 }
            
            let storeCoordinate = CLLocation(latitude: storeRegion[0].latitude!, longitude: storeRegion[0].longitude!)
            
            inTimeDict["distance"] = currentCoordinate.distance(from: storeCoordinate) // result is in meters
            
            //CALL API TO UPDATE INTIME
            self.setSpentTimeForStore(region: inTimeDict)
        }
    }
    */
    
    func checkIfClosestStoreNotAvailableThenStopMonitoring() {
        
        let storeIdArray : [Int] =  UserDefaults.standard.value(forKey: "closestStoreIdArray") as! [Int]
        
        for region in self.locationManager.monitoredRegions {
            print(region)
            
            let regionIdentifierId = region.identifier.components(separatedBy: " ").last
            
            if (!storeIdArray.contains(Int(regionIdentifierId!)!)) {
                
                //REMOVE AFTER GETTING OUTTIME FROM MONITORING ARRAY
                self.locationManager.stopMonitoring(for: region)
            }
        }
    }
    
    func moveToNextViewController() {
        if CLLocationManager.locationServicesEnabled() {
            RootViewControllerManager.refreshRootViewController()
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
        else {
            print("Location services are not enabled")
        }
    }
    
    func setSpentTimeForStore(region: [String: Any]) {
        
        storeNetworkTask?.cancel()
        
        storeNetworkTask = MoyaProvider<StoreApi>(plugins: [AuthPlugin()]).request(.setStoreSpentTime(regionObject: region)) { result in
            
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

    //Mark: - Schedule Local notification
    
    @objc func scheduleLocalNotification(body: String, title: String) {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = "Location"
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
}

extension TTILocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("NotDetermined")
        case .restricted, .denied, .authorizedWhenInUse:
            let alertController = UIAlertController().createSettingsAlertController(title: Bundle.main.displayName!, message: "Please enable location service to 'Always Allow' to use this app.")
            UIApplication.shared.windows[0].rootViewController?.present(alertController, animated: true, completion: nil)
        case .authorizedAlways:
            print("Access")
            self.moveToNextViewController()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        UserDefaults.standard.set(locValue.latitude, forKey: "CurrentLatitude")
        UserDefaults.standard.set(locValue.longitude, forKey: "CurrentLongitude")
        UserDefaults.standard.synchronize()
    }
   
    // CALLED WHEN USER ENTERED THE REGION
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            // Do what you want if this information
            
            let closestStoreIdArray: [Int] = UserDefaults.standard.value(forKey: "closestStoreIdArray") as! [Int]
            let identifier = region.identifier.components(separatedBy: " ")
            
            if closestStoreIdArray.contains(Int(identifier.last!)!) {
                
                var inTimeDict = [String: Any]()
                
                inTimeDict["storeID"] = Int(identifier.last!)
                inTimeDict["op"] = "enter"
                inTimeDict["timestamp"] = Date().currentTimeMillis()
                inTimeDict["latitude"] = String(format: "%f", (manager.location?.coordinate.latitude)!)
                inTimeDict["longitude"] = String(format: "%f", (manager.location?.coordinate.longitude)!)
                
                let currentCoordinate = CLLocation(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!)
                
                let storeRegion = self.locationsToMonitor.filter{ $0.id == Int((identifier.last!)) }
                
                let storeCoordinate = CLLocation(latitude: storeRegion[0].latitude!, longitude: storeRegion[0].longitude!)
                
                inTimeDict["distance"] = Int(currentCoordinate.distance(from: storeCoordinate)) // result is in meters
                
                //CALL API TO UPDATE INTIME
                self.setSpentTimeForStore(region: inTimeDict)
                
                //Schedule local notification
                self.scheduleLocalNotification(body: "Latitude: \(manager.location?.coordinate.latitude ?? 0) and Longitude: \(manager.location?.coordinate.longitude ?? 0)", title: "Entered region \(identifier.last!)")
                
            }
        }
    }
    
        // CALLED WHEN USER EXIT THE REGION
     func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        if region is CLCircularRegion {
            
            // Do what you want if this information
            let closestStoreIdArray: [Int] = UserDefaults.standard.value(forKey: "closestStoreIdArray") as! [Int]
            let identifier = region.identifier.components(separatedBy: " ")
            
            if closestStoreIdArray.contains(Int(identifier.last!)!) {
                
                var outTimeDict = [String: Any]()
                
                outTimeDict["storeID"] = Int(identifier.last!)
                outTimeDict["op"] = "exit"
                outTimeDict["timestamp"] = Date().currentTimeMillis()
                outTimeDict["latitude"] = String(format: "%f", (manager.location?.coordinate.latitude)!)
                outTimeDict["longitude"] = String(format: "%f", (manager.location?.coordinate.longitude)!)
                
                let currentCoordinate = CLLocation(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!)
                
                let storeRegion = self.locationsToMonitor.filter{ $0.id == Int((identifier.last!)) }
                
                let storeCoordinate = CLLocation(latitude: storeRegion[0].latitude!, longitude: storeRegion[0].longitude!)
                
                outTimeDict["distance"] = Int(currentCoordinate.distance(from: storeCoordinate)) // result is in meters

                //CALL API TO UPDATE OUTTIME
                self.setSpentTimeForStore(region: outTimeDict)
                
                //REMOVE AFTER GETTING OUTTIME FROM MONITORING ARRAY
              //  self.locationManager.stopMonitoring(for: region)
                
                //Schedule local notification
                self.scheduleLocalNotification(body: "Latitude: \(manager.location?.coordinate.latitude ?? 0) and Longitude: \(manager.location?.coordinate.longitude ?? 0)", title: "Exit region \(identifier.last!)")
            }
        }
    }
 
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        self.locationManager.requestState(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if (state == CLRegionState.inside) {
            self.locationManager(manager, didEnterRegion: region)
        }
    }
}


extension Date {
    func currentTimeMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970)
    }
}
