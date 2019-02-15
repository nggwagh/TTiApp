//
//  PeerExample.swift
//  TeamTTI
//
//  Created by Nikhil Wagh on 2/15/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import Foundation

struct PeerExample {
    let storeId: Int?
    let objectiveId: Int?
    let imageURL : [URL]?
}

extension PeerExample {
    
    static func build(from peerExampleJsonObjects: [[String:Any]]) -> [PeerExample] {
        return peerExampleJsonObjects.compactMap({ peerExampleJsonObject in
            return PeerExample( storeId: peerExampleJsonObject["storeID"] as? Int,
                            objectiveId: peerExampleJsonObject["objectiveID"] as? Int,
                            imageURL: ((peerExampleJsonObject["images"] != nil) ? ((peerExampleJsonObject["images"] as! [[String : AnyObject]]).compactMap{ return URL(string: $0["fileURL"] as! String)}) : []))
        })
    }
}
