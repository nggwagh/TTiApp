//
//  RegionsAPI.swift
//  TeamTTI
//
//  Created by Nikhil Wagh on 2/9/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import Foundation
import Moya


enum RegionsAPI {
    case getRegions()
    case getRegionsDetail()
}


extension RegionsAPI: TargetType {
    
    var baseURL: URL {
        return Constant.API.baseURL
    }
    
    var path: String {
        
        switch self {
        case .getRegions():
            return Constant.API.Region.getRegionsPath
            
        case .getRegionsDetail():
            return Constant.API.Region.getRegionsDetailPath
        }
    }
    
    var method: Moya.Method {
        
        switch self {
        case .getRegions():
            return .get
            
        case .getRegionsDetail():
            return .get
        }
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
