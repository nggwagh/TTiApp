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
                         date: DateFormatter.convertDateStringToMMMddyyyy(newsJsonObject["date"] as! String),
                         imageURL: ["https://pngimage.net/wp-content/uploads/2018/06/todays-news-png-2.png"])
                         //newsJsonObject["images"] as? Array
            
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
