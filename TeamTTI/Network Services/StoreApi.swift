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
}

extension StoreApi: TargetType {
    var baseURL: URL {
        
        switch self {
        case .stores():
            return URL(string: "\(Constant.API.baseURL)/?showCounts=1")!
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
        }
    }

    var method: Moya.Method {
        switch self {
        case .stores():
            return .get
        case .storeObjectivesFor:
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
        }
    }

    var headers: [String : String]? {
        return nil
    }

}
