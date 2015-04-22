//
//  MissFitClassSchedule.swift
//  missfit
//
//  Created by Hank Liang on 4/22/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import Foundation

class MissFitClassSchedule {
    var date: String
    var startTime: String
    var duration: Int
    
    init(json: JSON) {
        date = json["date"].stringValue
        startTime = json["startTime"].stringValue
        duration = json["duration"].int!
    }
}