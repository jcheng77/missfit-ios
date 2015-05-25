//
//  MissFitUtils.swift
//  missfit
//
//  Created by Hank Liang on 4/20/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import Foundation
import UIKit

public class MissFitUtils {
    public class func shortestScreenWidth() -> CGFloat {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height

        if screenWidth < screenHeight {
            return screenWidth
        } else {
            return screenHeight
        }
    }
    
    public class func longestScreenWidth() -> CGFloat {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        if screenWidth < screenHeight {
            return screenHeight
        } else {
            return screenWidth
        }
    }
    
    public class func formatDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.stringFromDate(date)
    }
    
    // Must be yyyy/MM/dd
    public class func dateFromString(dateString: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        if let date = dateFormatter.dateFromString(dateString) {
            return date
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.dateFromString(dateString)!
        }
    }
    
    public class func dateFromServer(dateString: String) -> NSDate {
        var date = (dateString as NSString).substringToIndex(10) as String
        return self.dateFromString(date)
    }
}