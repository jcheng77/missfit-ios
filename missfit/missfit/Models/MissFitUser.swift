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
        
        NSUserDefaults.standardUserDefaults().setObject(userInfo, forKey: MissFitUserInfo)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func logout() {
        userId = nil
        phoneNumber = nil
        passcode = nil
        token = nil
        nickName = nil
        avatarUrl = nil
        
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: MissFitUserInfo)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}