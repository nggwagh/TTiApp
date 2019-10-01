//
//  Objective.swift
//  TeamTTI
//
//  Created by Mayur Deshmukh on 11/11/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import Foundation

enum ObjectiveStatus: Int {
    case status0 = 0
    case status1 = 1

}

extension ObjectiveStatus{
    static func status(for value: Any) -> ObjectiveStatus {
        if let value = value as? Int {
            return ObjectiveStatus(rawValue: value)!
        }
        return .status0
    }
}

enum Priority: String {
    case high = "A"
    case medium = "B"
    case low = "C"
}

extension Priority {
    static func priority(for value: Any) -> Priority {
        if let value = value as? String {
            return Priority(rawValue: value)!
        }
        return .low
    }
}

extension Priority {
    var displayValue: String {
        switch self {
        case .high:
            return "HIGH"
        case .medium:
            return "MEDIUM"
        case .low:
            return "LOW"
        }
    }
}

enum ObjectiveType: Int {
    case defaultType = 0

    static func type(for value: Any) -> ObjectiveType {
        if let value = value as? Int {
            return ObjectiveType(rawValue: value)!
        }
        return .defaultType
    }
}

struct Objective {
    let id: Int
    let title: String
    let startDate: Date?
    let endDate: Date?
    let description: String?
//  let status: ObjectiveStatus
    let dueDate: Date?
    let priority: Priority?
    let type: ObjectiveType
    let trackProgress: Int?
    let createdBy: Int?
    let updatedBy: Int?
    let deletedAt: Date?
    let createdAt: Date?
    let updatedAt: Date?
    var playbookUrl: [URL]?
}

extension Objective {
    static func build(from objectiveJsonObjects: [[String: Any]]) -> [Objective] {
        return objectiveJsonObjects.compactMap { objectiveJsonObject in
            Objective(id: objectiveJsonObject["id"] as! Int,
                      title: objectiveJsonObject["title"] as! String,
                      startDate: DateFormatter.formatter_yyyyMMdd.parse(value: objectiveJsonObject["startDate"]),
                      endDate: DateFormatter.formatter_yyyyMMdd.parse(value: objectiveJsonObject["endDate"]),
                      description: objectiveJsonObject["description"] as? String,
                  //  status: .status(for: objectiveJsonObject["status"]!),
                      dueDate: DateFormatter.formatter_yyyyMMdd.parse(value: objectiveJsonObject["dueDate"]),
                      priority: .priority(for: objectiveJsonObject["priority"]!),
                      type: .type(for: objectiveJsonObject["type"]!),
                      trackProgress: objectiveJsonObject["trackProgress"] as? Int,
                      createdBy: objectiveJsonObject["createdBy"] as? Int,
                      updatedBy: objectiveJsonObject["updatedBy"] as? Int,
                      deletedAt: DateFormatter.formatter_yyyyMMdd_hhmmss.parse(value: objectiveJsonObject["deleted_at"]),
                      createdAt: DateFormatter.formatter_yyyyMMdd_hhmmss.parse(value: objectiveJsonObject["created_at"]),
                      updatedAt: DateFormatter.formatter_yyyyMMdd_hhmmss.parse(value: objectiveJsonObject["updated_at"]),
                      playbookUrl: ((objectiveJsonObject["playbook"] != nil) ? ((objectiveJsonObject["playbook"] as! [[String : AnyObject]]).compactMap
                        {
                            return URL(string: $0["fileURL"] as! String)
                      }) : []))
        }
    }
    
    static func build(from objectiveJsonObject: [String: Any]) -> Objective {
        return Objective(id: objectiveJsonObject["id"] as! Int,
                      title: objectiveJsonObject["title"] as! String,
                      startDate: DateFormatter.formatter_yyyyMMdd.parse(value: objectiveJsonObject["startDate"]),
                      endDate: DateFormatter.formatter_yyyyMMdd.parse(value: objectiveJsonObject["endDate"]),
                      description: objectiveJsonObject["description"] as? String,
           //         status: .status(for: objectiveJsonObject["status"]!),
                      dueDate: DateFormatter.formatter_yyyyMMdd.parse(value: objectiveJsonObject["dueDate"]),
                      priority: .priority(for: objectiveJsonObject["priority"]!),
                      type: .type(for: objectiveJsonObject["type"]!),
                      trackProgress: objectiveJsonObject["trackProgress"] as? Int,
                      createdBy: objectiveJsonObject["createdBy"] as? Int,
                      updatedBy: objectiveJsonObject["updatedBy"] as? Int,
                      deletedAt: DateFormatter.formatter_yyyyMMdd_hhmmss.parse(value: objectiveJsonObject["deleted_at"]),
                      createdAt: DateFormatter.formatter_yyyyMMdd_hhmmss.parse(value: objectiveJsonObject["created_at"]),
                      updatedAt: DateFormatter.formatter_yyyyMMdd_hhmmss.parse(value: objectiveJsonObject["updated_at"]),
                      playbookUrl: ((objectiveJsonObject["playbook"] != nil) ? ((objectiveJsonObject["playbook"] as! [[String : AnyObject]]).compactMap
                        {
                            return URL(string: $0["fileURL"] as! String)
                      }) : []))
        }
    }

private extension Objective {

}

/*
{
    "id": 1,
    "title": "First Objective",
    "startDate": "2018-11-01",
    "endDate": "2018-11-30",
    "description": "This is a sample objective, see the playbook for more details",
    "status": 0,
    "dueDate": "2018-11-07",
    "priority": "A",
    "type": 0,
    "trackProgress": 1,
    "createdBy": 1,
    "updatedBy": null,
    "deleted_at": null,
    "created_at": "2018-11-11 18:17:27",
    "updated_at": "2018-11-11 18:17:27"
}
*/
