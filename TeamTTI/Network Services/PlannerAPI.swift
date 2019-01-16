//
//  PlannerAPI.swift
//  TeamTTI
//
//  Created by Nikhil Wagh on 1/16/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import Foundation
import Moya


enum PlannerAPI {
    case getScheduleList()
}


extension PlannerAPI: TargetType{
    
    var baseURL: URL {
        return Constant.API.baseURL
    }
    
    var path: String {
        switch self {
        case .getScheduleList():
            return Constant.API.Planner.path
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil

    } 
}
