//
//  MissFitClass.swift
//  missfit
//
//  Created by Hank Liang on 4/22/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import Foundation

class MissFitClass {
    var classId: String
    var name: String
    var desc: String?
    var target: String?
    var schedule: MissFitClassSchedule
    var location: MissFitLocation
    var teacher: MissFitTeacher
    
    init(json: JSON) {
        classId = json["_id"].stringValue
        name = json["name"].stringValue
        desc = json["desc"].string
        target = json["target"].string
        schedule = MissFitClassSchedule(json: json["schedule"])
        location = MissFitLocation(json: json["location"])
        teacher = MissFitTeacher(json: json["teacher"])
    }
}