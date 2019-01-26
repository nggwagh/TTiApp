//
//  Playbook.swift
//  TeamTTI
//
//  Created by Nikhil Wagh on 1/26/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import Foundation

struct Playbook {
    let name: String?
    let fileType: String?
    let id: Int?
    let playbookURL : [URL]?
}

extension Playbook {
    
    static func build(from playbookJsonObjects: [[String:Any]]) -> [Playbook] {
        return playbookJsonObjects.compactMap({ playbookJsonObject in
            return Playbook(name: playbookJsonObject["name"] as? String,
                        fileType: playbookJsonObject["fileType"] as? String,
                        id: playbookJsonObject["id"] as? Int,
                        playbookURL: ((playbookJsonObject["files"] != nil) ? ((playbookJsonObject["files"] as! [[String : AnyObject]]).compactMap
                            {
                                return URL(string: $0["fileURL"] as! String)
                        }) : []))
        })
}
}
