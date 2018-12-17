//
//  UserApi.swift
//  TeamTTI
//
//  Created by Deepak Sharma on 08.11.18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import Foundation
import Moya



enum UserApi {
    case login(email: String, password: String)
}


extension UserApi: TargetType {
    var baseURL: URL {
        return Constant.API.baseURL
    }
    
    var path: String {
        switch self {
        case .login(_, _):
            return Constant.API.Login.path
        
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login(_, _):
            return .post
            
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        
        switch self {
        case let .login(email, password):
            return .requestParameters(parameters:
                ["grant_type": "password",
                 "client_id": "3",
                 "client_secret": "04073SrnNhj04Vl5hbvwlfDqhKUZ3BAvZBZqwRU2",
                 "username": email,
                 "password": password,
                 "scope": "*"],encoding: JSONEncoding.default)
            
        }
    }
    
    var headers: [String : String]? {
       return ["Content-type": "application/json"]
    }
    
    
}
