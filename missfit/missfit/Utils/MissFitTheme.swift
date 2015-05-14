//
//  MissFitTheme.swift
//  missfit
//
//  Created by Hank Liang on 4/19/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import Foundation

class MissFitTheme {
    class var theme: MissFitTheme {
        dispatch_once(&Inner.token) {
            Inner.instance = MissFitTheme()
        }
        return Inner.instance!
    }
    
    struct Inner {
        static var instance: MissFitTheme?
        static var token: dispatch_once_t = 0
    }
    
    var colorPink: UIColor = UIColor(red: 247.0 / 255.0, green: 126.0 / 255.0, blue: 164.0 / 255.0, alpha: 1.0)
    var colorDisabled: UIColor = UIColor.grayColor()
    var colorSilver: UIColor = UIColor(red: 230.0 / 255.0, green: 232.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    var colorHeaderBackground = UIColor(red: 239.0 / 255.0, green: 239.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
    var colorDarkText = UIColor(red: 33.0 / 255.0, green: 33.0 / 255.0, blue: 33.0 / 255.0, alpha: 1.0)
    var colorSeperator = UIColor(red: 200.0 / 255.0, green: 199.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
}
