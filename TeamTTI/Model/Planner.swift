//
//  Planner.swift
//  TeamTTI
//
//  Created by Nikhil Wagh on 1/16/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import Foundation
import UIKit

struct Planner {
    let id: Int
    let storeId: Int
    let objectiveID: Int
    let status: Int
    let estimatedCompletionDate: Date?
    let completionDate: Date?
    let comments: String?
    let createdBy: Int?
    let updatedBy: Int?
    let deletedAt: Date?
    let createdAt: Date?
    let updatedAt: Date?
    let objectiveName: String?
    let storeName: String?
    let incompleteReasonID: Int?

}


extension Planner {
    static func build(from plannerJsonObjects: [[String: Any]]) -> [Planner] {
        return plannerJsonObjects.compactMap{ plannerJsonObject in
            
            let objective = plannerJsonObject["objective"] as? [String: AnyObject]
            let store = plannerJsonObject["store"] as? [String: AnyObject]
            
           return Planner(id: plannerJsonObject["id"] as! Int,
                           storeId: plannerJsonObject["storeID"] as! Int,
                           objectiveID: plannerJsonObject["objectiveID"] as! Int,
                           status:  plannerJsonObject["status"] as! Int,
                           estimatedCompletionDate: DateFormatter.formatter_yyyyMMdd.parse(value: plannerJsonObject["estimatedCompletionDate"]),
                           completionDate: DateFormatter.formatter_yyyyMMdd.parse(value: plannerJsonObject["completionDate"]),
                           comments: plannerJsonObject["comments"] as? String,
                           createdBy: plannerJsonObject["createdBy"] as? Int,
                           updatedBy: plannerJsonObject["updatedBy"] as? Int,
                           deletedAt: DateFormatter.formatter_yyyyMMdd_HHmmss.parse(value: plannerJsonObject["deleted_at"]),
                           createdAt: DateFormatter.formatter_yyyyMMdd_HHmmss.parse(value: plannerJsonObject["created_at"]),
                           updatedAt: DateFormatter.formatter_yyyyMMdd_HHmmss.parse(value: plannerJsonObject["updated_at"]),
                           objectiveName: objective?["title"] as? String,
                           storeName: store?["name"] as? String,
                           incompleteReasonID: plannerJsonObject["incompleteReasonID"] as? Int)
        }
    }
}
