//
//  SettingsManager.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 05/02/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit

class SettingsManager: NSObject {

    private static var sharedInstance: SettingsManager  =  {
        let settingsManager = SettingsManager()
        return settingsManager
    }()
    
    // This prevents others from using the default '()' initializer for this class.
    override private init() {
        super.init()
    }
    
    // MARK:- Accessor - Shared instance
    class func shared() -> SettingsManager {
        return sharedInstance
    }
    
    // MARK:- User ID -
    func setUserID(_ userID: String) {
        UserDefaults.standard.set(userID, forKey: Constant.API.User.userID)
        UserDefaults.standard.synchronize()
    }
    func getUserID() -> String? {
        let userID = UserDefaults.standard.string(forKey: Constant.API.User.userID)
        return (userID)
    }
    
    // MARK:- User AccessToken -
    func setAccessToken(_ userAccessToken: String) {
        UserDefaults.standard.set(userAccessToken, forKey: Constant.API.Login.accessToken)
        UserDefaults.standard.synchronize()
    }
    func getAccessToken() -> String? {
        let token = UserDefaults.standard.string(forKey: Constant.API.Login.accessToken)
        return (token)
    }
    
    // MARK:- User RefreshToken -
    func setRefreshToken(_ userRefreshToken: String) {
        UserDefaults.standard.set(userRefreshToken, forKey: Constant.API.Login.refreshToken)
        UserDefaults.standard.synchronize()
    }
    func getRefreshToken() -> String? {
        let token = UserDefaults.standard.string(forKey: Constant.API.Login.refreshToken)
        return (token)
    }
    
    // MARK:- User location Latitude -
    func setUserLocationLatitude(_ latitude: Double) {
        UserDefaults.standard.set(latitude, forKey: Constant.API.User.currentLatitude)
        UserDefaults.standard.synchronize()
    }
    func getUserLocationLatitude() -> Double? {
        let latitude = UserDefaults.standard.double(forKey: Constant.API.User.currentLatitude)
        return (latitude)
    }
    
    // MARK:- User location Longitude -
    func setUserLocationLongitude(_ longitude: Double) {
        UserDefaults.standard.set(longitude, forKey: Constant.API.User.currentLongitude)
        UserDefaults.standard.synchronize()
    }
    func getUserLocationLongitude() -> Double? {
        let longitude = UserDefaults.standard.double(forKey: Constant.API.User.currentLongitude)
        return (longitude)
    }
    
    // MARK:- User location Latitude launchtime -
    func setUserLocationLaunchTimeLatitude(_ latitude: Double) {
        UserDefaults.standard.set(latitude, forKey: Constant.API.User.currentLatitude_launchtime)
        UserDefaults.standard.synchronize()
    }
    func getUserLocationLaunchTimeLatitude() -> Double? {
        let latitude = UserDefaults.standard.double(forKey: Constant.API.User.currentLatitude_launchtime)
        return (latitude)
    }
    
    // MARK:- User location Longitude launchtime -
    func setUserLocationLaunchTimeLongitude(_ longitude: Double) {
        UserDefaults.standard.set(longitude, forKey: Constant.API.User.currentLongitude_launchtime)
        UserDefaults.standard.synchronize()
    }
    func getUserLocationLaunchTimeLongitude() -> Double? {
        let longitude = UserDefaults.standard.double(forKey: Constant.API.User.currentLongitude_launchtime)
        return (longitude)
    }
    
    // MARK:- Empty user default -
    func resetSettings() {
        UserDefaults.standard.removeObject(forKey: Constant.API.User.userID)
        UserDefaults.standard.removeObject(forKey: Constant.API.Login.accessToken)
        UserDefaults.standard.removeObject(forKey: Constant.API.Login.refreshToken)
        UserDefaults.standard.removeObject(forKey: Constant.API.User.currentLatitude)
        UserDefaults.standard.removeObject(forKey: Constant.API.User.currentLongitude)

        UserDefaults.standard.synchronize()
    }
}

