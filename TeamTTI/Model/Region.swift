//
//  Region.swift
//  TeamTTI
//
//  Created by Nikhil Wagh on 2/9/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import Foundation

struct Region {
    let id: Int?
    let name: String?
    let code: String?
}

extension Region {
    
    static func build(from RegionJsonObjects: [[String:Any]]) -> [Region] {
        return RegionJsonObjects.compactMap({ regionJsonObject in
            return Region(id: regionJsonObject["id"] as? Int,
                          name: regionJsonObject["name"] as? String,
                          code: regionJsonObject["code"] as? String)
        })
    }
}
