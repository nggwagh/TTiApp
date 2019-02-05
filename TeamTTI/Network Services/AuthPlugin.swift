//
//  AuthPlugin.swift
//  TeamTTI
//
//  Created by Mayur Deshmukh on 11/11/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import Foundation
import Moya

struct AuthPlugin: PluginType {

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.addValue("Bearer " + SettingsManager.shared().getAccessToken()!, forHTTPHeaderField: "Authorization")
        request.addValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        return request
    }
}
