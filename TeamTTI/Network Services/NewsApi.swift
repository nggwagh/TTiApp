//
//  NewsApi.swift
//  TeamTTI
//
//  Created by Nikhil Wagh on 12/25/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import Foundation
import Moya

enum NewsApi {
    case news()
}

extension NewsApi: TargetType {
    var baseURL: URL {
        return Constant.API.baseURL
    }
    
    var path: String {
        switch self {
        case .news():
            return Constant.API.News.path
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
