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
    var classScopes: [String] = [String]()
    var address: String?
    var teachModes: [String] = [String]()
    var coverPicUrl: String?
    var pics: [String] = [String]()
    var avatarUrl: String?
    var idVerified: Bool = false
    var price: String?
    var teacherCertification: MissFitTeacherCertification?
    var distance: String?
    var teachAreas: String?
    var likesCount: Int = 0
    var commentsCount: Int = 0
    
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
        address = json["address"].string
        
        for (teachModeIndex: String, teachMode: JSON) in json["teachModes"] {
            teachModes.append(teachMode.string!)
        }
        
        self.coverPicUrl = json["coverPic"].string
        
        for (picIndex: String, picURL: JSON) in json["pics"] {
            pics.append(picURL.string!)
        }
        
        self.avatarUrl = json["touxiang"].string
        self.idVerified = json["verified"].boolValue
        
        self.price = json["price"].stringValue
        self.teachAreas = json["shangmenAddress"].string
        self.teacherCertification = MissFitTeacherCertification(json: json["certified"])
        if json["distance"] != nil {
            self.distance = json["distance"].stringValue
        }
        
        if let number = json["likesCount"].number {
            self.likesCount = number.integerValue
        }
        
        if let number = json["commentsCount"].number {
            self.commentsCount = number.integerValue
        }
    }
    
    func classScopesString() -> String {
        var scopesString = ""
        for scope in classScopes {
            scopesString += "、\(scope)"
        }
        if count(scopesString) > 0 {
            let startIndex = advance(scopesString.startIndex, 1)
            scopesString = scopesString.substringFromIndex(startIndex)
        }

        return scopesString
    }
    
    func teachModesString() -> String {
        var modesString = ""
        for mode in teachModes {
            modesString += "、\(mode)"
        }
        if count(modesString) > 0 {
            let startIndex = advance(modesString.startIndex, 1)
            modesString = modesString.substringFromIndex(startIndex)
        }
        return modesString
    }
}