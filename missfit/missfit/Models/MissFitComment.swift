//
//  MissFitComment.swift
//  missfit
//
//  Created by Hank Liang on 6/22/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import Foundation

class MissFitComment {
    var userName: String?
    var date: String?
    var userIcon: String?
    var score: Int?
    
    init() {}
    
    init(json: JSON) {
        userName = json["userName"].string
        date = json["date"].string
        if date != nil {
            date = MissFitUtils.formatDate(MissFitUtils.dateFromServer(date!))
        }
        userIcon = json["pic"].string
        score = json["score"].int
    }
}