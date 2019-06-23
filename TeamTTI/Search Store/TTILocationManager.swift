//
//  TTILocationManager.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 22/06/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit
import MapKit
import Moya
//import UserNotifications

class TTILocationManager: NSObject {
    
    //MARK:- Instance Variables
    let locationManager = CLLocationManager()
    static let sharedLocationManager = TTILocationManager()
    private var locationsToMonitor = [Store]()
    
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
        
        locationManager.distanceFilter = 200
        
        locationManager.allowsBackgroundLocationUpdates = true
        
        locationManager.pausesLocationUpdatesAutomatically = true
        
        locationManager.startUpdatingLocation()
    }
    
    //MARK:- Private methods
    
    func moveToNextViewController() {
        if CLLocationManager.locationServicesEnabled() {
            RootViewControllerManager.refreshRootViewController()
            self.startUpdatingCurrentLocation()
        }
        else {
            print("Location services are not enabled")
        }
    }
    
    func saveCurrentLocationLocally() {
        if let currentLocation = self.locationManager.location {
            var currentLocationDetails = CurrentLocationDetails()
            currentLocationDetails.currentlatitude = String(format: "%f", (currentLocation.coordinate.latitude))
            currentLocationDetails.currentlongitude = String(format: "%f", (currentLocation.coordinate.longitude))
            currentLocationDetails.timestamp = String(format: "%d", Date().currentTimeMillis())
            TTILocationDBManager.save(currentLocationDetails: currentLocationDetails)
        }
    }
  
    func sendLocations() {
        
        let savedLocations = TTILocationDBManager.fetchLocations()
        var locationsInputArray = [[String:Any]]()
        
        if (savedLocations.count > 0) {
            
            for location in savedLocations {
                print("Location: \(location.currentlatitude ?? ""), \(location.currentlatitude ?? ""), \(location.timestamp ?? "")")
                var locDict = [String: Any]()
                locDict["latitude"] = location.currentlatitude
                locDict["longitude"] = location.currentlongitude
                locDict["timestamp"] = Int(location.timestamp!)
                locationsInputArray.append(locDict)
            }
            
            MoyaProvider<UserApi>(plugins: [AuthPlugin()]).request(.setLocationDetails(userId: SettingsManager.shared().getUserID()!, locationDetails: locationsInputArray)) { result in
                
                switch result {
                case let .success(response):
                    if case 200..<400 = response.statusCode {
                        let responseString = String(data: response.data, encoding: String.Encoding.utf8)
                        TTILocationDBManager.deleteLocations(locations: savedLocations)
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
//        guard let locValue: CLLocationCoordinate2D = locations.last?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.saveCurrentLocationLocally()
    }
}

