//
//  StorePerformance.swift
//  TeamTTI
//
//  Created by Nikhil Wagh on 5/24/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import Foundation

struct StorePerformance {
    
    let id: Int?
    let storeNumber: Int?
    let storeName: String?
    let userID: Int?
    let totalObjectives: Int?
    let completed: Int?
    let repName: String?


    
}

extension StorePerformance {
    
    static func build(from storeJsonObjects: [[String:Any]]) -> [StorePerformance] {
        return storeJsonObjects.compactMap({ storeJsonObject in
            
            let count = storeJsonObject["counts"] as? [String: Any]
            let user = storeJsonObject["user"] as? [String: Any]
            
            return StorePerformance(id: storeJsonObject["id"] as? Int,
                                    storeNumber: storeJsonObject["storeNumber"] as? Int,
                                    storeName: storeJsonObject["name"] as? String,
                                    userID: storeJsonObject["userID"] as? Int,
                                    totalObjectives: count?["totalObjectives"] as? Int,
                                    completed: count?["completed"] as? Int,
                                    repName: user?["name"] as? String)
        })
    }
    
    
    init(id: Int, storeNumber: Int, storeName: String, userID: Int, totalObjectives: Int, completed: Int, repName: String) {
        self.id = id
        self.storeNumber = storeNumber
        self.storeName = storeName
        self.userID = userID
        self.totalObjectives = totalObjectives
        self.completed = completed
        self.repName = repName
    }
}

/*
 {
 "id": 1,
 "regionID": 2,
 "storeNumber": 1234,
 "userID": 1,
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
 "latitude": "-75.5524",
 "longitude": "43.848",
 "timezone": "null",
 "isOptOut": 0,
 "createdBy": null,
 "updatedBy": null,
 "deleted_at": null,
 "created_at": "2018-11-11 18:15:56",
 "updated_at": "2018-11-11 18:15:56",
 "name": "Juan Store",
 "counts": {
 "totalObjectives": 30,
 "completed": 10
 },
 "user": {
 "id": 1,
 "name": "Juan Garcia",
 "email": "juan@pulpandfiber.com",
 "created_at": "2018-10-23 05:24:02",
 "updated_at": "2019-03-11 13:12:02",
 "role": 1,
 "createdBy": null,
 "updatedBy": 1,
 "firstName": "Juan",
 "lastName": "Garcia",
 "deviceToken": "266e794085e89bcf09ef37700d699ceff482e7b04e317da592145506e6e1ef1f",
 "deviceID": "8293DAFE-BC41-4F15-BCA9-68E8FDA6496D",
 "regionID": 2,
 "isGeoSupervisor": 1
 }
 }
*/
