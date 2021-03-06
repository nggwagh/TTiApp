//
//  Store.swift
//  TeamTTI
//
//  Created by Mayur Deshmukh on 11/11/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import Foundation
import MapKit

struct Store {
    let name: String
    let id: Int
    let regionID: Int
    let storeNumber: Int?
    let userID: Int?
    let addressLine1: String?
    let addressLine2: String?
    let city: String?
    let province: String?
    let postalCode: String?

    let phoneNo: String?
    let storeManager: String?
    let SMEmail: String?
    let assistantManager: String?
    let AMEmail: String?
    let hardwareDS: String?
    let SDSEmail: String?

    let timezone: String?
    let createdBy: Int?
    let updatedBy: Int?
    let deleted_at: Int?
    let updated_at: Int?
    let created_at: Int?

    let isHDC: Bool

    let latitude: Double?
    let longitude: Double?
    
    let totalObjectives: Int?
    let completed: Int?
    
    let distanceFromCurrentLocation: Double?
}

extension Store {

    static func build(from storesJsonObjects: [[String:Any]]) -> [Store] {
        return storesJsonObjects.compactMap({ storeJsonObject in
            
            let countDictionary = storeJsonObject["counts"] as? [String: Any]
            
            let currentCoordinate = CLLocation(latitude: SettingsManager.shared().getUserLocationLatitude()!, longitude: SettingsManager.shared().getUserLocationLongitude()!)

            let storeLatitude = (storeJsonObject["latitude"] != nil) ?  Double((storeJsonObject["latitude"] as? String)!) : 0
            let storeLongitude = (storeJsonObject["longitude"] != nil) ? Double((storeJsonObject["longitude"] as? String)!) : 0

            return Store(name: storeJsonObject["name"] as! String,
                         id: storeJsonObject["id"] as! Int,
                         regionID: storeJsonObject["regionID"] as! Int,
                         storeNumber: storeJsonObject["storeNumber"] as? Int,
                         userID: storeJsonObject["userID"] as? Int,
                         addressLine1: storeJsonObject["addressLine1"] as? String,
                         addressLine2: storeJsonObject["addressLine2"] as? String,
                         city: storeJsonObject["city"] as? String,
                         province: storeJsonObject["province"] as? String,
                         postalCode: storeJsonObject["postalCode"] as? String,
                         phoneNo: storeJsonObject["phoneNo"] as? String,
                         storeManager: storeJsonObject["storeManager"] as? String,
                         SMEmail: storeJsonObject["SMEmail"] as? String,
                         assistantManager: storeJsonObject["assistantManager"] as? String,
                         AMEmail: storeJsonObject["AMEmail"] as? String,
                         hardwareDS: storeJsonObject["hardwareDS"] as? String,
                         SDSEmail: storeJsonObject["SDSEmail"] as? String,
                         timezone: storeJsonObject["timezone"] as? String,
                         createdBy: storeJsonObject["createdBy"] as? Int,
                         updatedBy: storeJsonObject["updatedBy"] as? Int,
                         deleted_at: storeJsonObject["deleted_at"] as? Int,
                         updated_at: storeJsonObject["updated_at"] as? Int,
                         created_at: storeJsonObject["created_at"] as? Int,
                         isHDC: storeJsonObject["isHDC"] as! Bool,
                         latitude: storeLatitude, //"37.785834" as AnyObject,
                longitude: storeLongitude, //"-122.406417" as AnyObject
                         totalObjectives:countDictionary?["totalObjectives"] as? Int,
                         completed:countDictionary?["completed"] as? Int,
                         distanceFromCurrentLocation: currentCoordinate.distanceFromCurrentLocationInMiles(latitude: storeLatitude!, longitude: storeLongitude!))
        })
    }
}

extension Array where Element == Store {
    var closest: Store? {
        get {
            //TODO: Calculate closest from user's location
            return self.first
        }
    }
}


/*
{
    "id": 1,
    "regionID": 2,
    "storeNumber": 1234,
    "userID": null,
    "addressLine1": "123 nowhere rd",
    "addressLine2": null,
    "city": "Toronto",
    "province": "ON",
    "postalCode": "M4M4M4",
    "phoneNo": "4165551212",
    "storeManager": null,
    "SMEmail": null,
    "assistantManager": "",
    "AMEmail": null,
    "hardwareDS": null,
    "HDSEmail": null,
    "seasonalDS": null,
    "SDSEmail": null,
    "isHDC": 0,
    "latitude": null,
    "longitude": null,
    "timezone": "null",
    "createdBy": null,
    "updatedBy": null,
    "deleted_at": null,
    "created_at": "2018-11-11 18:15:56",
    "updated_at": "2018-11-11 18:15:56",
    "name": "Juan Store",
    "user": null
}
*/
