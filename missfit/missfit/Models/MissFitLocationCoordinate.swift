//
//  MissFitLocationCoordinate.swift
//  missfit
//
//  Created by Hank Liang on 5/18/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import Foundation

class MissFitLocationCoordinate {
    var longtitude: Double
    var latitude: Double
    
    init(json: JSON) {
        longtitude = json["lng"].doubleValue
        latitude = json["lat"].doubleValue
    }
}
