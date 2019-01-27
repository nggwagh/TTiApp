//
//  AuthPlugin.swift
//  TeamTTI
//
//  Created by Mayur Deshmukh on 11/11/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import Foundation
import Moya
import KeychainSwift

struct AuthPlugin: PluginType {
  //  static let token = KeychainSwift().get(Constant.API.Login.accessToken)!

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.addValue("Bearer " + KeychainSwift().get(Constant.API.Login.accessToken)!, forHTTPHeaderField: "Authorization")
        request.addValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        return request
    }
}
