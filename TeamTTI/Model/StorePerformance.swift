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
    let name: String?
    let userID: Int?
    
}

extension StorePerformance {
    
    static func build(from storeJsonObjects: [[String:Any]]) -> [StorePerformance] {
        return storeJsonObjects.compactMap({ storeJsonObject in
            return StorePerformance(id: storeJsonObject["id"] as? Int,
                                    storeNumber: storeJsonObject["storeNumber"] as? Int,
                                    name: storeJsonObject["name"] as? String,
                                    userID: storeJsonObject["userID"] as? Int)
        })
    }
    
    
    init(id: Int, storeNumber: Int, name: String, userID: Int) {
        self.id = id
        self.storeNumber = storeNumber
        self.name = name
        self.userID = userID
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
    "name": "Juan Store"
}
*/
