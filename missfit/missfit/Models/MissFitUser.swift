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
        self.loginDate = MissFitUtils.formatDate(NSDate())
        
        var userInfo = [String: String]()
        userInfo[MissFitUserId] = userId
        userInfo[MissFitUserPhoneNumber] = phoneNumber
        userInfo[MissFitUserToken] = token
        userInfo[MissFitUserPasscode] = passcode
        userInfo[MissFitUserNickName] = nickName
        userInfo[MissFitUserAvatarUrl] = avatarUrl
        //TODO: also need load the membership info
        
        // Set the login date
        userInfo[MissFitUserLoginDate] = loginDate
        
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
        var userInfo = [String: String]()
        userInfo[MissFitUserId] = userId
        userInfo[MissFitUserPhoneNumber] = phoneNumber
        userInfo[MissFitUserToken] = token
        userInfo[MissFitUserPasscode] = passcode
        userInfo[MissFitUserNickName] = nickName
        userInfo[MissFitUserAvatarUrl] = avatarUrl
        userInfo[MissFitUserHasMonthlyCard] = hasMonthlyCard ? "1" : "0"
        userInfo[MissFitUserMonthlyCardValidThrough] = monthlyCardValidThrough
        userInfo[MissFitUserLoginDate] = loginDate
        
        NSUserDefaults.standardUserDefaults().setObject(userInfo, forKey: MissFitUserInfo)
        NSUserDefaults.standardUserDefaults().synchronize()
        

    }
    
    func parseMembershipData(responseObject: NSDictionary) {
        let json = JSON(responseObject)
        for (key: String, subJson: JSON) in json {
            if key == "data" {
                self.hasMonthlyCard = subJson["profile"]["isMember"].boolValue
                if let memberExpiredDate = subJson["profile"]["memberExpired"].string {
                    self.monthlyCardValidThrough = MissFitUtils.formatDate(MissFitUtils.dateFromServer(memberExpiredDate))
                }
                self.nickName = subJson["profile"]["name"].string
                self.extendMembership()
            }
        }
    }
    
    func loadMembershipInfo() {
        var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        var endpoint: String = MissFitBaseURL + MissFitMembershipURI + self.userId!
        KVNProgress.show()
        manager.requestSerializer.setValue(MissFitUser.user.userId, forHTTPHeaderField: "X-User-Id")
        manager.requestSerializer.setValue(MissFitUser.user.token, forHTTPHeaderField: "X-Auth-Token")
        manager.GET(endpoint, parameters: nil, success: { (operation, responseObject) -> Void in
            KVNProgress.dismiss()
            self.parseMembershipData(responseObject as! NSDictionary)
            NSNotificationCenter.defaultCenter().postNotificationName(MissFitLoadMembershipSucceededCallback, object: nil)
        }) { (operation, error) -> Void in
            if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                // Need to get the status and message
                let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData)
                let message: String? = json["message"].string
                KVNProgress.showErrorWithStatus(message)
            } else {
                KVNProgress.showErrorWithStatus("获取会员信息失败")
            }
            NSNotificationCenter.defaultCenter().postNotificationName(MissFitLoadMembershipFailureCallback, object: nil)
        }
    }
    
    func isMonthlyCardExpired() ->Bool {
        if monthlyCardValidThrough == nil {
            return true
        } else {
            if MissFitUtils.dateFromString(monthlyCardValidThrough!).timeIntervalSinceDate(NSDate().dateByAddingTimeInterval(24.0 * 3600)) > 0 {
                // Valid date is farther away from tomorrow
                return false
            } else {
                return true
            }
        }
    }
}