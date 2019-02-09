//
//  RegionDetail.swift
//  TeamTTI
//
//  Created by Nikhil Wagh on 2/9/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import Foundation

struct RegionDetail {
    let id: Int?
    let name: String?
    let objectiveStatusIds: String?
    let hasComments: Bool?
    let isPastDue: Bool?
    let isWarning: Bool?
    let slug: String?
    let isPastDeadline: Bool?
    let count : [String: Int]?
}


extension RegionDetail {
    
    static func build(from RegionDetailJsonObjects: [[String:Any]]) -> [RegionDetail] {
        return RegionDetailJsonObjects.compactMap({ regionDetailJsonObject in
            return RegionDetail(id: regionDetailJsonObject["id"] as? Int,
                                name: regionDetailJsonObject["name"] as? String,
                                objectiveStatusIds: regionDetailJsonObject["objective_status_ids"] as? String,
                                hasComments: regionDetailJsonObject["has_comments"] as? Bool,
                                isPastDue: regionDetailJsonObject["is_past_due"] as? Bool,
                                isWarning: regionDetailJsonObject["is_warning"] as? Bool,
                                slug: regionDetailJsonObject["slug"] as? String,
                                isPastDeadline: regionDetailJsonObject["is_past_deadline"] as? Bool,
                                count: regionDetailJsonObject["count"] as? [String: Int])
        })
    }
}

/*
{
    "id": 1,
    "name": "In Progress",
    "objective_status_ids": "2",
    "has_comments": 0,
    "is_past_due": 0,
    "is_warning": 0,
    "slug": "scheduled",
    "created_at": null,
    "updated_at": null,
    "is_past_deadline": 0,
    "count": {
        "1": 1,
        "2": 2,
        "3": 0,
        "4": 0,
        "5": 4,
        "6": 0
    }
}
*/
