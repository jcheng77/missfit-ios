//
//  MissFitLocation.swift
//  missfit
//
//  Created by Hank Liang on 4/20/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import Foundation

class MissFitLocation {
    var locationId: String
    var name: String
    var phone: String
    var district: String
    var address: String
    var area: String?
    var picUrl: String?
    
    init(json: JSON) {
        locationId = json["_id"].stringValue
        district = json["district"].stringValue
        address = json["address"].stringValue
        area = json["area"].string
        name = json["name"].stringValue
        phone = json["phone"].stringValue
        picUrl = json["pic"].string
    }
}
