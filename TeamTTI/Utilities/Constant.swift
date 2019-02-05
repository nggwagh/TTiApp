//
//  Constant.swift
//  TeamTTI
//
//  Created by Deepak Sharma on 08.11.18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import Foundation

struct Constant {

    struct API {
        static let baseURL = URL.init(string: "http://test.teamtti.ca")!

        struct Login {
            static let path = "oauth/token"
            static let accessToken = "access_token"
            static let refreshToken = "refresh_token"
        }
        
        struct User {
            static let path = "/api/v1/user/me"
            static let userID = "userId"
            static let resetPasswordAPIPath = "/api/v1/user/reset_password"
        }

        struct Store {
            static let path = "api/v1/store"
            static let geoItemPath = "api/v1/geoitem"
        }

        struct Objective {
            static let path = "api/v1/objective"
        }
        
        struct News {
            static let path = "api/v1/news"
            static let playbookPath = "api/v1/quicklink"

        }
        
        struct Planner {
            static let path = "api/v1/user/me/schedule"
        }
    }

    struct Storyboard {
        
    }



}

struct Constants {
    //Common constants
    static let headerTitle = "headerTitle"
    static let storeObjectives = "storeObjectives"
    static let taskValueUpdated = "TaskValueUpdated"
    
    static let objectives = "objectives"
    static let counts = "counts"
    static let totalObjectives = "totalObjectives"
    static let completed = "completed"
    static let closestStoreIdArray = "closestStoreIdArray"
    static let objectiveID = "objectiveID"
    static let storeID = "storeID"
    static let estimatedCompletionDate = "estimatedCompletionDate"
    static let comments = "comments"
    
    //Alert messages
    static let objectivesScheduleSuccess = "Objectives scheduled successfully."
    static let scheduledPastDueDateMessage = "Please explain why the objective is scheduled past the due date:"
    static let selectSameDueDateMessage = "Please only select objectives in the same due date group for scheduling."
    static let selectObjectiveMessage = "Please select the Objectives."
    
    //UITableviewCell identifiers
    static let graphTableViewCell = "GraphTableViewCell"
    static let storeObjectiveTableViewCell = "StoreObjectiveTableViewCell"
    
    //Image names
    static let tti_blue = "tti_blue"
    static let upArrow = "UpArrow"
    static let down_arrow = "down_arrow"
}
