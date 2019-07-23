//
//  TTILocationManagerOld.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 13/01/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit
import MapKit
import Moya
import UserNotifications


class TTILocationManagerOld: NSObject {
    
    //MARK:- Instance Variables
    let locationManager = CLLocationManager()
    static let sharedLocationManager = TTILocationManagerOld()
    private var locationsToMonitor = [Store]()
    private var storeNetworkTask: Cancellable?
    let refreshStoreDistance = 10.0 //in km
    
    private var recordedTimeStamp = Date()
    
    //MARK:- Instance Methods
    
    override init() {}
    
    func checkLocationAuthorization() {
        // Ask for Authorisation from the User.
        locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
    }
    
    func startUpdatingCurrentLocation() {
        
        // Ask for Authorisation from the User.
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        locationManager.allowsBackgroundLocationUpdates = true
        
        locationManager.pausesLocationUpdatesAutomatically = true
        
//      locationManager.startMonitoringSignificantLocationChanges()
        
        locationManager.startUpdatingLocation()
    }
    
    func monitorRegions(regionsToMonitor : [Store])  {
        
        self.locationsToMonitor = regionsToMonitor
        
        for location in self.locationsToMonitor {
            
            let geofenceRegionCenter = CLLocationCoordinate2DMake(CLLocationDegrees((location.latitude)!), CLLocationDegrees((location.longitude)!))
            
            let identifier = String(location.name + " " + "\(location.id)")
            let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter,
                                                  radius: 500,
                                                  identifier: identifier)
            
            //SAVE CLOSEST STORE ARRAY
            var closestStoresArray = [String]()
            if let storeIdArray : [String] =  UserDefaults.standard.value(forKey: "closestStoreIdArray") as? [String] {
                closestStoresArray.append(contentsOf: storeIdArray)
            }
            
            
            if (!closestStoresArray.contains(location.id.description)) {
                
                closestStoresArray.append(location.id.description)
                
                UserDefaults.standard.set(closestStoresArray, forKey: "closestStoreIdArray")
                UserDefaults.standard.synchronize()
                
                geofenceRegion.notifyOnEntry = true
                geofenceRegion.notifyOnExit = true
                
                print("Created region: \(geofenceRegion)")
                
                self.locationManager.startMonitoring(for: geofenceRegion)
            }
        }
        //CODE TO CHECK AND REMOVE REGION MONITORING IF ITS NOT BELONGS TO CLOSED STORES THEN REMOVE REGION MONITORING
        self.checkIfClosestStoreNotAvailableThenStopMonitoring()
        
        //test code for api testing
        // self.dummyTestApi()
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
        
        let closestStoreIdArray : [String] =  self.locationsToMonitor.compactMap{ return $0.id.description }.sorted()
        
        for region in self.locationManager.monitoredRegions {
            
            let regionIdentifierId = region.identifier.components(separatedBy: " ").last
            
            if (!closestStoreIdArray.contains(regionIdentifierId!)) {
                
                print("Removed region: \(region)")
                
                //REMOVE AFTER GETTING OUTTIME FROM MONITORING ARRAY
                self.locationManager.stopMonitoring(for: region)
                
                // REMOVING FROM USERDEFAULTS
                UserDefaults.standard.set(closestStoreIdArray, forKey: "closestStoreIdArray")
                UserDefaults.standard.synchronize()
                
            }
        }
    }
    
    func moveToNextViewController() {
        if CLLocationManager.locationServicesEnabled() {
            RootViewControllerManager.refreshRootViewController()
            self.startUpdatingCurrentLocation()
        }
        else {
            print("Location services are not enabled")
        }
    }
    
    func updateStoreRegionState(region: CLRegion, state: String) {
        
        if (state == "enter") {
            let elapsed = Date().timeIntervalSince(recordedTimeStamp)
            recordedTimeStamp = Date()
            print("Time elapsed\(elapsed)")
            if (elapsed < 5) {
                return
            }
        }
        
        if let currentLocation = self.locationManager.location {
            
            if region is CLCircularRegion {
                // Do what you want if this information
                
                if let closestStoreIdArray = UserDefaults.standard.value(forKey: "closestStoreIdArray") as? [String] {
                    
                    if (closestStoreIdArray.count > 0) {
                     
                        let identifier = region.identifier.components(separatedBy: " ")

                        let isValidStoreId = identifier.last?.isNumber
                        
                        if isValidStoreId! {
                           
                            if (closestStoreIdArray.contains(identifier.last!))
                            {
                                var inTimeDict = [String: Any]()
                                inTimeDict["storeID"] = Int(identifier.last!)
                                inTimeDict["op"] = state
                                inTimeDict["timestamp"] = Date().currentTimeMillis()
                                inTimeDict["latitude"] = String(format: "%f", (currentLocation.coordinate.latitude))
                                inTimeDict["longitude"] = String(format: "%f", (currentLocation.coordinate.longitude))
                                
                                let currentCoordinate : CLLocation? = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                                
                                let storeRegion: [Store]? = self.locationsToMonitor.filter{ $0.id == Int((identifier.last!)) }
                                
                                if ((storeRegion?.count)! > 0 && storeRegion != nil && currentCoordinate != nil) {
                                    let storeCoordinate : CLLocation? = CLLocation(latitude: storeRegion![0].latitude!, longitude: storeRegion![0].longitude!)
                                    
                                    if (storeCoordinate != nil) {
                                        var distance =  Int(currentCoordinate?.distance(from: storeCoordinate!) ?? 0) // result is in meters
                                        if (distance < 0) {
                                            distance = 0
                                        }
                                        inTimeDict["distance"] = distance
                                    }
                                    else {
                                        inTimeDict["distance"] = 0
                                    }
                                   
                                    //CALL API TO UPDATE INTIME
                                    self.setSpentTimeForStore(region: inTimeDict)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setSpentTimeForStore(region: [String: Any]) {
        
        MoyaProvider<StoreApi>(plugins: [AuthPlugin()]).request(.setStoreSpentTime(regionObject: region)) { result in
            
            switch result {
            case let .success(response):
                if case 200..<400 = response.statusCode {
                    let responseString = String(data: response.data, encoding: String.Encoding.utf8)
                    print(responseString!)
                } else {
                    let responseString = String(data: response.data, encoding: String.Encoding.utf8)
                    print(responseString!)
                }
                
            case let .failure(error):
                print(error.localizedDescription) //MOYA error
            }
        }
    }
    
    func refreshMonitoringStores() {
        
        storeNetworkTask?.cancel()
        
        storeNetworkTask = MoyaProvider<StoreApi>(plugins: [AuthPlugin()]).request(.stores()) { result in
            
            switch result {
            case let .success(response):
                if case 200..<400 = response.statusCode {
                    do {
                        let jsonDict =   try JSONSerialization.jsonObject(with: response.data, options: []) as! [[String: Any]]
                        print(jsonDict)
                        
                        //Sort array by Closest stores first
                        let stores = Store.build(from: jsonDict).sorted(by: { (store1 : Store, store2 : Store) -> Bool in
                            return Int(store1.distanceFromCurrentLocation!) < Int(store2.distanceFromCurrentLocation!)
                        })
                        
                        //start monitoring for top 5 closest stores
                        var closestStores = [Store]()
                        if stores.count >= 5 {
                            for i in 0...4 {
                                closestStores.append(stores[i])
                            }
                        }
                        TTILocationManagerOld.sharedLocationManager.monitorRegions(regionsToMonitor: closestStores)
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                }
                else {
                    let responseString = String(data: response.data, encoding: String.Encoding.utf8)
                    print(responseString!)
                }
                
            case let .failure(error):
                print(error.localizedDescription) //MOYA error
            }
        }
    }
}


extension TTILocationManagerOld: CLLocationManagerDelegate {
    
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
        guard let locValue: CLLocationCoordinate2D = locations.last?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        SettingsManager.shared().setUserLocationLatitude(locValue.latitude)
        SettingsManager.shared().setUserLocationLongitude(locValue.longitude)
        
        let launchTimeLat = SettingsManager.shared().getUserLocationLaunchTimeLatitude()
        let launchTimeLong = SettingsManager.shared().getUserLocationLaunchTimeLongitude()
        
        if (launchTimeLat == 0 && launchTimeLong == 0) {
            SettingsManager.shared().setUserLocationLaunchTimeLatitude(locValue.latitude)
            SettingsManager.shared().setUserLocationLaunchTimeLongitude(locValue.longitude)
        }
        else {
            if let _ = SettingsManager.shared().getUserID() {

                let currentCoordinate = CLLocation(latitude: SettingsManager.shared().getUserLocationLatitude()!, longitude: SettingsManager.shared().getUserLocationLongitude()!)
                
                let distance = currentCoordinate.distanceFromCurrentLocationInMiles(latitude: launchTimeLat!, longitude: launchTimeLong!)
                
                if (distance >= refreshStoreDistance) {

                    //UPDATING LAT/LONG TO LATEST
                    SettingsManager.shared().setUserLocationLaunchTimeLatitude(locValue.latitude)
                    SettingsManager.shared().setUserLocationLaunchTimeLongitude(locValue.longitude)

                    if ((RootViewControllerFactory.centerContainer.centerViewController?.isKind(of: UINavigationController.self))!){
                        let currentViewController = (RootViewControllerFactory.centerContainer.centerViewController as! UINavigationController).viewControllers[0]
                        if (currentViewController.isKind(of: HomeViewController.self)) {
                            (currentViewController as! HomeViewController).loadStores()
                        }
                        else {
                            //refresh stores and start monitoring here
                            self.refreshMonitoringStores()
                        }
                    }
                }
            }
        }
    }
    
    // CALLED WHEN USER ENTERED THE REGION
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.updateStoreRegionState(region: region, state: "enter")
    }
    
    // CALLED WHEN USER EXIT THE REGION
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        self.updateStoreRegionState(region: region, state: "exit")
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        self.locationManager.requestState(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if (state == CLRegionState.inside) {
            self.updateStoreRegionState(region: region, state: "enter")
        }
    }
}

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}