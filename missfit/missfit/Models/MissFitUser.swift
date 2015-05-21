//
//  MissFitUser.swift
//  missfit
//
//  Created by Hank Liang on 4/25/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import Foundation

class MissFitUser {
    class var user: MissFitUser {
        dispatch_once(&Inner.token) {
            Inner.instance = MissFitUser()
        }
        return Inner.instance!
    }
    
    struct Inner {
        static var instance: MissFitUser?
        static var token: dispatch_once_t = 0
    }
    
    init() {
        // Read data from userDefaults
        var userInfo: [String: String]? = NSUserDefaults.standardUserDefaults().objectForKey(MissFitUserInfo) as? [String: String]
        userId = userInfo?[MissFitUserId]
        phoneNumber = userInfo?[MissFitUserPhoneNumber]
        token = userInfo?[MissFitUserToken]
        passcode = userInfo?[MissFitUserPasscode]
        nickName = userInfo?[MissFitUserNickName]
        avatarUrl = userInfo?[MissFitUserAvatarUrl]
        if let monthlyCardString = userInfo?[MissFitUserHasMonthlyCard] {
            hasMonthlyCard = (monthlyCardString as NSString).boolValue
        }
        monthlyCardValidThrough = userInfo?[MissFitUserMonthlyCardValidThrough]
        loginDate = userInfo?[MissFitUserLoginDate]
    }
    
    var userId: String?
    var phoneNumber: String?
    var passcode: String?
    var token: String?
    var nickName: String?
    var avatarUrl: String?
    var isLogin: Bool {
        return userId != nil && token != nil
    }
    var hasMonthlyCard: Bool = false
    var monthlyCardValidThrough: String?
    var loginDate: String?
    
    func login(userId: String, userPhoneNumber: String, userToken: String, userPasscode: String) {
        self.userId = userId
        self.phoneNumber = userPhoneNumber
        self.token = userToken
        self.passcode = userPasscode
        
        var userInfo = [String: String]()
        userInfo[MissFitUserId] = userId
        userInfo[MissFitUserPhoneNumber] = phoneNumber
        userInfo[MissFitUserToken] = token
        userInfo[MissFitUserPasscode] = passcode
        userInfo[MissFitUserNickName] = nickName
        userInfo[MissFitUserAvatarUrl] = avatarUrl
        //TODO: also need load the membership info
        
        // Set the login date
        userInfo[MissFitUserLoginDate] = MissFitUtils.formatDate(NSDate())
        
        NSUserDefaults.standardUserDefaults().setObject(userInfo, forKey: MissFitUserInfo)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func checkTokenExpired() {
        if self.isLogin {
            if let dateString = self.loginDate {
                let date = MissFitUtils.dateFromString(dateString)
                let twentyDaysInterval: Double = 20.0 * 24 * 3600
                if NSDate().timeIntervalSinceDate(date) > twentyDaysInterval {
                    self.logout()
                }
            } else {
                self.logout()
            }
        }
    }
    
    func logout() {
        userId = nil
        phoneNumber = nil
        passcode = nil
        token = nil
        nickName = nil
        avatarUrl = nil
        hasMonthlyCard = false
        monthlyCardValidThrough = nil
        
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: MissFitUserInfo)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func extendMembership() {
        self.hasMonthlyCard = true
        let oneMonthTimeInterval: Double = 3600 * 24 * 30
        if let validThrough = self.monthlyCardValidThrough {
            self.monthlyCardValidThrough = MissFitUtils.formatDate(NSDate(timeInterval: oneMonthTimeInterval, sinceDate: MissFitUtils.dateFromString(validThrough)))
        } else {
            self.monthlyCardValidThrough = MissFitUtils.formatDate(NSDate(timeInterval: oneMonthTimeInterval, sinceDate: NSDate()))
        }
        
        var userInfo = [String: String]()
        userInfo[MissFitUserId] = userId
        userInfo[MissFitUserPhoneNumber] = phoneNumber
        userInfo[MissFitUserToken] = token
        userInfo[MissFitUserPasscode] = passcode
        userInfo[MissFitUserNickName] = nickName
        userInfo[MissFitUserAvatarUrl] = avatarUrl
        userInfo[MissFitUserHasMonthlyCard] = hasMonthlyCard ? "1" : "0"
        userInfo[MissFitUserMonthlyCardValidThrough] = monthlyCardValidThrough
        
        NSUserDefaults.standardUserDefaults().setObject(userInfo, forKey: MissFitUserInfo)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}