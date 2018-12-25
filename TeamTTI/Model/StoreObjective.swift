//
//  StoreObjective.swift
//  TeamTTI
//
//  Created by Mayur Deshmukh on 18/11/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import Foundation
import UIKit

enum StoreObjectiveStatus: Int {
    case incomplete = 0
    case complete = 1
    case notApplicable = 2
}

extension StoreObjectiveStatus {
    static func status(for value: Any) -> StoreObjectiveStatus {
        if let value = value as? Int {
            return StoreObjectiveStatus(rawValue: value)!
        }
        return .incomplete
    }
}

extension StoreObjectiveStatus {
    var iconImage: UIImage {
        switch self {
        case .incomplete:
            return UIImage(named: "objective_incomplete")!
        case .complete:
            return UIImage(named: "objective_complete")!
        case .notApplicable:
            return UIImage(named: "objective_paused")!
        }
    }
}

struct StoreObjective {
    let id: Int
    let storeId: Int
    let objectiveID: Int
    let status: StoreObjectiveStatus
    let estimatedCompletionDate: Date?
    let completionDate: Date?
    let comments: String?
    let createdBy: Int?
    let updatedBy: Int?
    let deletedAt: Date?
    let createdAt: Date?
    let updatedAt: Date?
    let images: [URL]

    var objective: Objective? {
        get {
            return ObjectiveDataProvider.shared.objectiveList?.filter{ $0.id == self.objectiveID }.first
        }
    }
}

extension StoreObjective {
    static func build(from storeObjectiveJsonObjects: [[String: Any]]) -> [StoreObjective] {
        return storeObjectiveJsonObjects.compactMap{ storeObjectiveJsonObject in
            StoreObjective(id: storeObjectiveJsonObject["id"] as! Int,
                           storeId: storeObjectiveJsonObject["storeID"] as! Int,
                           objectiveID: storeObjectiveJsonObject["objectiveID"] as! Int,
                           status: .status(for: storeObjectiveJsonObject["status"]!),
                           estimatedCompletionDate: DateFormatter.formatter_yyyyMMdd.parse(value: storeObjectiveJsonObject["estimatedCompletionDate"]),
                           completionDate: DateFormatter.formatter_yyyyMMdd.parse(value: storeObjectiveJsonObject["completionDate"]),
                           comments: storeObjectiveJsonObject["comments"] as? String,
                           createdBy: storeObjectiveJsonObject["createdBy"] as? Int,
                           updatedBy: storeObjectiveJsonObject["updatedBy"] as? Int,
                           deletedAt: DateFormatter.formatter_yyyyMMdd_hhmmss.parse(value: storeObjectiveJsonObject["deleted_at"]),
                           createdAt: DateFormatter.formatter_yyyyMMdd_hhmmss.parse(value: storeObjectiveJsonObject["created_at"]),
                           updatedAt: DateFormatter.formatter_yyyyMMdd_hhmmss.parse(value: storeObjectiveJsonObject["updated_at"]),
                           images: (storeObjectiveJsonObject["images"] as! [String]).compactMap{ return URL(string: $0) } )
        }
    }
}

/*
 {
 "id": 1,
 "storeID": 2,
 "objectiveID": 1,
 "status": 0,
 "estimatedCompletionDate": null,
 "completionDate": null,
 "comments": "",
 "createdBy": 1,
 "updatedBy": null,
 "deleted_at": null,
 "created_at": "2018-11-11 18:17:27",
 "updated_at": "2018-11-11 18:17:27",
 "images": []
 }
 */