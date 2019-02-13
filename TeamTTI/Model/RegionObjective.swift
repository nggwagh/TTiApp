//
//  RegionObjective.swift
//  TeamTTI
//
//  Created by Nikhil Wagh on 2/13/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import Foundation

struct RegionObjective {
    let objective: String?
    let store: String?
    let storeNumber: Int?
    let fsr: String?
    let dueDate: String?
    let estimationCompletionDate: String?
    let comment: String?
}


extension RegionObjective {
    
    static func build(from RegionObjectiveJsonObjects: [[String:Any]]) -> [RegionObjective] {
        return RegionObjectiveJsonObjects.compactMap({ regionObjectiveJsonObject in
            
            let objective = regionObjectiveJsonObject["objective"] as? [String: Any]
            let store = regionObjectiveJsonObject["store"] as? [String: Any]
            let user = store!["user"] as? [String: Any]
            
            return RegionObjective(objective: objective!["title"] as? String,
                                store: store!["name"] as? String,
                                storeNumber: store!["storeNumber"] as? Int,
                                fsr: user!["name"] as? String,
                                dueDate: objective!["dueDate"] as? String,
                                estimationCompletionDate: regionObjectiveJsonObject["estimatedCompletionDate"] as? String,
                                comment: regionObjectiveJsonObject["comments"] as? String)
        })
    }
}


/*
{
    "id": 16638,
    "storeID": 41,
    "objectiveID": 724,
    "status": 2,
    "estimatedCompletionDate": "2019-02-05",
    "completionDate": null,
    "comments": null,
    "incompleteReasonID": null,
    "createdBy": null,
    "updatedBy": 14,
    "deleted_at": null,
    "created_at": null,
    "updated_at": "2019-02-01 20:46:48",
    "objective": {
        "id": 724,
        "title": "A - Q1 RIDGID Brand Tower",
        "startDate": "2019-02-01",
        "endDate": "2019-02-26",
        "description": "Please refer to Feb. Playbook for details.",
        "status": 1,
        "dueDate": "2019-02-26",
        "priority": "A",
        "type": 0,
        "trackProgress": 1,
        "createdBy": null,
        "updatedBy": null,
        "deleted_at": null,
        "created_at": null,
        "updated_at": null
    },
    "store": {
        "id": 41,
        "regionID": 1,
        "storeNumber": 7041,
        "userID": 14,
        "addressLine1": "",
        "addressLine2": "",
        "city": "",
        "province": "",
        "postalCode": "",
        "phoneNo": "",
        "storeManager": "",
        "SMEmail": "",
        "assistantManager": "",
        "AMEmail": "",
        "hardwareDS": "",
        "HDSEmail": "",
        "seasonalDS": "",
        "SDSEmail": "",
        "isHDC": 0,
        "latitude": "49.12212479999999",
        "longitude": "-122.6668164",
        "timezone": "",
        "createdBy": null,
        "updatedBy": null,
        "deleted_at": null,
        "created_at": null,
        "updated_at": null,
        "name": "LANGLEY",
        "user": {
            "id": 14,
            "name": "Lauren Felesky",
            "email": "lauren.felesky@ttigroupna.com",
            "created_at": null,
            "updated_at": "2019-01-16 13:27:32",
            "role": 1,
            "createdBy": null,
            "updatedBy": null,
            "firstName": "Lauren",
            "lastName": "Felesky",
            "deviceToken": null,
            "deviceID": null,
            "regionID": null
        }
    }
}
*/
