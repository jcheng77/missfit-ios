//
//  MissFitTeacherCertification.swift
//  missfit
//
//  Created by Hank Liang on 5/5/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import Foundation


class MissFitTeacherCertification {
    var isPhoneCertified: Bool = false
    var isIdCertified: Bool = false
    
    init(json: JSON) {
        isPhoneCertified = json["phone"].boolValue
        isIdCertified = json["ID"].boolValue
    }
    
    var isCertified: Bool {
        return isPhoneCertified || isIdCertified
    }
}