//
//  StoreApi.swift
//  TeamTTI
//
//  Created by Mayur Deshmukh on 11/11/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import Foundation
import Moya

enum StoreApi {
    
    case stores()
    case storeObjectivesFor(storeId: Int, month: String, year: Int)
    case setStoreSpentTime(regionObject: [String: Any])
    case getStorePerformanceList(regionId: Int)
    case getStorePerformanceObjective(storeId: Int)

}

extension StoreApi: TargetType {
    var baseURL: URL {
        
        switch self {
            
        case .stores():
            return URL(string: "\(Constant.API.baseURL)/?showCounts=1")!
            
        case let .storeObjectivesFor(_,month,year):
            return  URL(string: "\(Constant.API.baseURL)/?month=\(month)&year=\(year)")!
            
        case let .getStorePerformanceList(regionId):
            return  URL(string: "\(Constant.API.baseURL)/?regionID=\(regionId)&showCounts=1")!
            
        default:
            return Constant.API.baseURL
        }
    }

    var path: String {
        switch self {
            
        case .stores():
            return Constant.API.Store.path
            
        case let .storeObjectivesFor(storeId, _, _):
            return Constant.API.Store.path + "/\(storeId)/objective"

        case .setStoreSpentTime(_):
            return Constant.API.Store.geoItemPath
            
        case .getStorePerformanceList(_):
            return Constant.API.Store.path + "/search"

        case .getStorePerformanceObjective(let storeId):
            return Constant.API.Store.path + "/\(storeId)/objective"

        }
    }

    var method: Moya.Method {
        switch self {
            
        case .stores():
            return .get
            
        case .storeObjectivesFor:
            return .get
            
        case .setStoreSpentTime:
            return .post
            
        case .getStorePerformanceList(_):
            return .get
            
        case .getStorePerformanceObjective(_):
            return .get

        }

    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
            
        case .stores():
               return .requestPlain
            
        case .storeObjectivesFor:
            return .requestPlain
            
        case .setStoreSpentTime(let regionObject):
            print("Geo Item parameters: \(regionObject)")
            return .requestParameters(parameters:regionObject,
                                      encoding: JSONEncoding.default)
            
        case .getStorePerformanceList(_):
            return .requestPlain
            
        case .getStorePerformanceObjective(_):
            return .requestPlain

        }
    }

    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }

}
