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
    case getRegionObjectives(Status: Int, RegionID: Int)

}


extension RegionsAPI: TargetType {
    
    var baseURL: URL {
        
        switch self {
        case .getRegions():
            return Constant.API.baseURL
            
        case .getRegionsDetail():
            return Constant.API.baseURL
            
        case .getRegionObjectives(_, let regionID):
            return URL(string: "\(Constant.API.baseURL)/?regionID=\(regionID)")!

        }
  }
    
    var path: String {
        
        switch self {
        case .getRegions():
            return Constant.API.Region.getRegionsPath
            
        case .getRegionsDetail():
            return Constant.API.Region.getRegionsDetailPath
            
        case .getRegionObjectives(let status,_):
            return "api/v1/store_objective/status/\(status)/list"

        }
    }
    
    var method: Moya.Method {
        
        switch self {
        case .getRegions():
            return .get
            
        case .getRegionsDetail():
            return .get
            
        case .getRegionObjectives(_,_):
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
