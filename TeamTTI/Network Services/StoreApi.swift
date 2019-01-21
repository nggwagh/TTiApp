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
    case storeObjectivesFor(storeId: Int)
    case setStoreSpentTime(storeId: Int, op: String, timeStamp: Int, latitude: Double, longitude: Double, distance: Int)
}

extension StoreApi: TargetType {
    var baseURL: URL {
        
        switch self {
        case .stores():
            return URL(string: "\(Constant.API.baseURL)/?showCounts=1")!
        case .setStoreSpentTime(_, _, _, _, _, _):
            return Constant.API.baseURL
        default:
            return Constant.API.baseURL
        }
    }

    var path: String {
        switch self {
        case .stores():
            return Constant.API.Store.path 
        case let .storeObjectivesFor(storeId):
            return Constant.API.Store.path + "/\(storeId)/objective"
        case let .setStoreSpentTime(storeId, _, _, _, _, _):
            return Constant.API.Store.geoItemPath + "/\(storeId)"
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
        case let .setStoreSpentTime(storeId, op, timeStamp, latitude, longitude, distance):
            return .requestParameters(parameters:
                ["StoreID": storeId,
                 "op": op,
                 "timestamp": timeStamp,
                 "latitude": latitude,
                 "longitude": longitude,
                 "distance": distance],encoding: JSONEncoding.default)
        }
    }

    var headers: [String : String]? {
        return nil
    }

}
