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
    case playbooks()
    case survey()


}

extension NewsApi: TargetType {
    var baseURL: URL {
        return Constant.API.baseURL
    }
    
    var path: String {
        switch self {
        case .news():
            return Constant.API.News.path
            
        case .playbooks():
            return Constant.API.News.playbookPath
            
        case .survey():
            return Constant.API.News.surveyPath
            
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
