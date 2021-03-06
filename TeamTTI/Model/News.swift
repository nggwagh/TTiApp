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
    let detail: String
    let id: Int
    let date: String?
    let imageURL : [String]?
}

extension News {
    
    static func build(from newsJsonObjects: [[String:Any]]) -> [News] {
        return newsJsonObjects.compactMap({ newsJsonObject in
            return News(title: newsJsonObject["subject"] as! String,
                        detail: newsJsonObject["content"] as! String,
                         id: newsJsonObject["id"] as! Int,
                         date: Date.convertDateString(inputDateFormat: DateFormats.yyyyMMdd_HHmmss, outputDateFormat: DateFormats.MMMddyyyy, (newsJsonObject["date"] as! String)),
                         imageURL: (newsJsonObject["images"] != nil) ? (newsJsonObject["images"] as? Array) : [])
        })
    }
    
    
    
    init(title: String, detail: String, id: Int, date: String, imageURL : [String]) {
        self.title = title
        self.detail = detail
        self.id = id
        self.date = date
        self.imageURL = imageURL
    }
}


/*
 {
 "id": 1,
 "subject": "First News",
 "content": "Hi there",
 "date": "2018-12-08 16:32:27",
 "isPasive": 0,
 "created_at": null,
 "updated_at": null,
 "deleted_at": null,
 "images": []
 }
*/
