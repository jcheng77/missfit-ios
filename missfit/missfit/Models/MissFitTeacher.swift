//
//  MissFitTeacher.swift
//  missfit
//
//  Created by Hank Liang on 4/20/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import Foundation

class MissFitTeacher {
    var teacherId: String
    var name: String
    var info: String?
    var manifesto: String?
    var classScopes: [String]?
    var address: String?
    var teachModes: [String] = [String]()
    var coverPicUrl: String?
    var pics: [String] = [String]()
    var avatarUrl: String?
    var idVerified: Bool = false
    
    init(json: JSON) {
        teacherId = json["_id"].stringValue
        name = json["name"].stringValue
        info = json["info"].string
        manifesto = json["xuanyan"].string
        var classesScope = [String]()
        for (classIndex: String, classType: JSON) in json["classScopes"] {
            classesScope.append(classType.string!)
        }
        classScopes = classesScope
        address = json["location"].string
        
        for (teachModeIndex: String, teachMode: JSON) in json["teachModes"] {
            teachModes.append(teachMode.string!)
        }
        
        self.coverPicUrl = json["coverPic"].string
        
        for (picIndex: String, picURL: JSON) in json["pics"] {
            pics.append(picURL.string!)
        }
        
        self.avatarUrl = json["touxiang"].string
        self.idVerified = json["verified"].boolValue
    }
}