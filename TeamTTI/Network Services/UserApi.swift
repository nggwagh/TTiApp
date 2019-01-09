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
    case userDetails()
    case resetPassword(email: String)
}


extension UserApi: TargetType {
    var baseURL: URL {
        return Constant.API.baseURL
    }
    
    var path: String {
        switch self {
        case .login(_, _):
            return Constant.API.Login.path
        
        case .userDetails():
            return Constant.API.User.path
            
        case .resetPassword(_):
            return Constant.API.User.resetPasswordAPIPath
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login(_, _):
            return .post
           
        case .userDetails():
            return .get
            
        case .resetPassword(_):
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
            
        case .userDetails():
            return .requestPlain
            
        case let .resetPassword(email):
            return .requestParameters(parameters:
                ["email": email],encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
       return ["Content-type": "application/json"]
    }
    
    
}
