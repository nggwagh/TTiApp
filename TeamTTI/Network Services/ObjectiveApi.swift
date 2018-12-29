//
//  ObjectiveApi.swift
//  TeamTTI
//
//  Created by Mayur Deshmukh on 12/11/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import Foundation
import Moya

enum ObjectiveApi {
    case list
    case schedule(objectiveArray: [AnyObject])
}

extension ObjectiveApi: TargetType {
    var baseURL: URL {
        return Constant.API.baseURL
    }

    var path: String {
        switch self {
        case .list:
            return Constant.API.Objective.path
            
        case .schedule(_):
            return "api/v1/store_objective/schedule"
        }
    }

    var method: Moya.Method {
        
        switch self {
        case .list:
            return .get
        case .schedule(_):
            return .post
        }
    }

//    var parameters: [String: AnyObject]? {
//
//        switch self {
//            case .schedule(let objectiveArray):
//                return [ "parameterName": objectiveArray as AnyObject ]
//        case .list:
//            return nil
//        }
//    }
//
//    var parameterEncoding: Moya.ParameterEncoding {
//        switch self {
//        case .schedule(_):
//            return JSONEncoding.default
//        default:
//            return JSONEncoding.default
//        }
//    }
    
    var sampleData: Data {
        return Data()
    }

    var task: Task {
        
        switch self {
        case .list:
            return .requestPlain
        case .schedule(_):
            return .requestPlain
          //  return .requestParameters(parameters: (objectiveArray as AnyObject) as! [String : Any], encoding: JSONEncoding.default)
        }
    }

    var headers: [String : String]? {
        return nil
    }

}
