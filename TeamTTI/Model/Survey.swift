//
//  Survey.swift
//  TeamTTI
//
//  Created by Nikhil Wagh on 5/11/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import Foundation

struct Survey {
    let title: String?
    let detail: String?
    let id: Int?
    let date: String?
    let surveyURL : String?
}

extension Survey {
    
    static func build(from surveysJsonObjects: [[String:Any]]) -> [Survey] {
        return surveysJsonObjects.compactMap({ surveyJsonObject in
            return Survey(title: surveyJsonObject["name"] as? String,
                        detail: surveyJsonObject["comments"] as? String,
                        id: surveyJsonObject["id"] as? Int,
                        date: Date.convertDateString(inputDateFormat: DateFormats.yyyyMMdd_HHmmss, outputDateFormat: DateFormats.MMMddyyyy, (surveyJsonObject["created_at"] as! String)),
                        surveyURL: surveyJsonObject["url"] as? String)
        })
    }
    
    
    
    init(title: String, detail: String, id: Int, date: String, surveyURL : String) {
        self.title = title
        self.detail = detail
        self.id = id
        self.date = date
        self.surveyURL = surveyURL
    }
}
