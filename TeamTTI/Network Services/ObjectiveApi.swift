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
}

extension ObjectiveApi: TargetType {
    var baseURL: URL {
        return Constant.API.baseURL
    }

    var path: String {
        switch self {
        case .list:
            return Constant.API.Objective.path
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
