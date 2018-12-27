//
//  Constant.swift
//  TeamTTI
//
//  Created by Deepak Sharma on 08.11.18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import Foundation

struct Constant {

    struct API {
        static let baseURL = URL.init(string: "http://test.teamtti.ca")!

        struct Login {
            static let path = "oauth/token"
            static let accessToken = "access_token"
            static let refreshToken = "refresh_token"
        }

        struct Store {
            static let path = "api/v1/store"
        }

        struct Objective {
            static let path = "api/v1/objective"
        }
        
        struct News {
            static let path = "api/v1/news"
        }
        
    }

    struct Storyboard {
        
    }



}

