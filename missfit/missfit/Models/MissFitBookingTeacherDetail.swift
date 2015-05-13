//
//  MissFitBookingTeacherDetail.swift
//  missfit
//
//  Created by Hank Liang on 5/13/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import Foundation

class MissFitBookingTeacherDetail {
    var expectedDate: String?
    var bookingName: String?
    var bookingPhone: String?
    var address: String?
    
    init(json: JSON) {
        expectedDate = json["date"].string
        bookingName = json["name"].string
        bookingPhone = json["phone"].string
        address = json["address"].string
    }
}