//
//  MissFitBookingTeacher.swift
//  missfit
//
//  Created by Hank Liang on 5/13/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import Foundation

class MissFitBookingTeacher {
    var bookingId: String
    var actionDate: String
    var teacherAvatar: String?
    var teacherName: String?
    var detail: MissFitBookingTeacherDetail
    
    init(json: JSON) {
        bookingId = json["_id"].stringValue
        actionDate = json["book_date"].stringValue
        teacherAvatar = json["teacher_avatar"].string
        teacherName = json["teacher_name"].string
        detail = MissFitBookingTeacherDetail(json: json["details"])
    }
}