//
//  MissFitConstants.swift
//  missfit
//
//  Created by Hank Liang on 4/15/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import Foundation

let MissFitBaseURL: String = "http://missfit-api.boluo.me/"

let MissFitVerifyCodeURI: String = "codes?mobile="

let MissFitRegisterURI: String = "users"

let MissFitResetURI: String = "changePassword"

let MissFitLoginURI: String = "login"

let MissFitLogoutURI: String = "logout"

let MissFitTeachersURI: String = "teachers"

let MissFitClassesURI: String = "classes"

let MissFitClassesDateURI: String = "?date="

let MissFitClassesBookingURI: String = "/bookings"

let MissFitMyClassesURI: String = "bookings/class"

let MissFitMyTeachersURI: String = "bookings/teacher"

let MissFitTeachersLocationURI: String = "?location="

let MissFitSharingClassURI: String = "http://missfit.boluo.me/classes/"

let MissFitSharingTeacherURI: String = "http://missfit.boluo.me/teachers/"

let MissFitTermsOfUseURI: String = "http://missfit-static.boluo.me/termsofuse.html"

let MissFitPaymentCallbackURI: String = "orders/alipay/notify"

let MissFitOrdersURI: String = "orders"

let MissFitMembershipURI: String = "users/" // + userId

let MissFitSettings: String = "settings"

let MissFitLocations: String = "locations"



// MissFit user related:

let MissFitUserInfo: String = "MissFitUserInfo"

let MissFitUserId: String = "MissFitUserId"

let MissFitUserPhoneNumber: String = "MissFitUserPhoneNumber"

let MissFitUserToken: String = "MissFitUserToken"

let MissFitUserNickName: String = "MissFitUserNickName"

let MissFitUserPasscode: String = "MissFitUserPasscode"

let MissFitUserAvatarUrl: String = "MissFitUserAvatarUrl"

let MissFitUserHasMonthlyCard: String = "MissFitUserHasMonthlyCard"

let MissFitUserMonthlyCardValidThrough: String = "MissFitUserMonthlyCardValidThrough"

let MissFitUserLoginDate: String = "MissFitUserLoginDate"

// Notifications 
let MissFitAlipaySucceededCallback: String = "MissFitAlipaySucceededCallback"

let MissFitLoadMembershipSucceededCallback: String = "MissFitLoadMembershipSucceededCallback"

let MissFitLoadMembershipFailureCallback: String = "MissFitLoadMembershipFailureCallback"
