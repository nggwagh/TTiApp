//
//  News.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 15/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import Foundation

struct News {
    let title: String
    let id: Int
    let date: String?
    let imageURL : String?
}

extension News {
    
    static func build(from newsJsonObjects: [[String:Any]]) -> [News] {
        return newsJsonObjects.compactMap({ newsJsonObject in
            return News(title: newsJsonObject["name"] as! String,
                         id: newsJsonObject["id"] as! Int,
                         date: newsJsonObject["date"] as? String,
                         imageURL: newsJsonObject["imageURL"] as? String)
        })
    }
    
    init(title: String, id: Int, date: String, imageURL : String) {
        self.title = title
        self.id = id
        self.date = date
        self.imageURL = imageURL
    }
}
