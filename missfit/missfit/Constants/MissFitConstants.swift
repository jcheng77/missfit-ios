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

let MissFitCommentsURI: String = "comments"

let MissFitLikesURI: String = "praises"

let MissFitClassesURI: String = "classes"

let MissFitFeaturedClasses: String = "?featured=true"

let MissFitClassesDateURI: String = "?date="

let MissFitClassesBookingURI: String = "bookings"

let MissFitMyClassesURI: String = "bookings/class"

let MissFitMyTeachersURI: String = "bookings/teacher"

let MissFitTeachersLocationURI: String = "?location="

let MissFitSharingClassURI: String = "http://missfit.boluo.me/classes/"

let MissFitSharingTeacherURI: String = "http://missfit.boluo.me/teachers/"

let MissFitTermsOfUseURI: String = "http://missfit-static.boluo.me/termsofuse.html"

let MissFitMemberCardInfoURI: String = "http://missfit-static.boluo.me/membercardrules.html"

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

let MissFitLoadWeeklyClasses: String = "MissFitLoadWeeklyClasses"

// MARK: - Analytics
let AnalyticsBookClassButNotLogin: String = "book_class_but_not_login" // 点了预约课程但是没登录
let AnalyticsBookClassButNotPay: String = "book_class_but_not_pay" // 点了预约课程但是没购买会员
let AnalyticsBookClassSucceed: String = "book_class_succeed" // 预约课程成功
let AnalyticsCancelBookingClassSucceed: String = "cancel_booking_class_succeed" // 取消预约成功
let AnalyticsClickBookingClass: String = "click_booking_class" // 点击预约课程
let AnalyticsClickBookingTeacher: String = "click_booking_teacher" // 点击预约上门
let AnalyticsClickCancelClass: String = "click_cancel_class" // 点击取消预约
let AnalyticsClickClassDetail: String = "click_class_detail" // 点击查看课程详情
let AnalyticsClickClasses: String = "click_classes" // 选课程
let AnalyticsClickWeeklyClasses: String = "click_weekly_classes" // 点击每周课程
let AnalyticsClickForgotPassword: String = "click_forgot_password" // 点击找回密码
let AnalyticsClickLocationClasses: String = "click_location_classes" // 点击分馆课程
let AnalyticsClickLocationDetail: String = "click_location_detail" // 点击查看场馆信息
let AnalyticsClickLocationRoute: String = "click_location_route" // 点击获取场馆路线
let AnalyticsClickMCI: String = "click_mci" // 点击月卡使用规则
let AnalyticsClickMyClasses: String = "click_my_classes" // 点击我的课程
let AnalyticsClickMyClassesButNotLogin: String = "click_my_classes_but_not_login" // 点击我的课程但是没有登录
let AnalyticsClickPayment: String = "click_payment" // 点击去支付
let AnalyticsClickRegister: String = "click_register" // 点击注册
let AnalyticsClickSettings: String = "click_settings" // 点击设置
let AnalyticsClickSettingsButNotLogin: String = "click_settings_but_not_login" // 点击设置但没有登录
let AnalyticsClickShareClass: String = "click_share_class" // 点击分享课程
let AnalyticsClickShareTeacher: String = "click_share_teacher" // 点击分享老师
let AnalyticsClickTeacherClasses: String = "click_teacher_classes" // 点击查看老师课表
let AnalyticsClickTeacherDetail: String = "click_teacher_detail" // 点击查看老师详情
let AnalyticsClickTeachers: String = "click_teachers" // 选老师
let AnalyticsClickTOU: String = "click_tou" // 点击服务条款
let AnalyticsConfirmBookingClass: String = "confirm_booking_class" // 确认预约课程
let AnalyticsConfirmCancelBookingClass: String = "confirm_cancel_booking_class" // 确认取消预约课程
let AnalyticsDial400: String = "dial_400" // 点击400电话
let AnalyticsEnterPayment: String = "enter_payment" // 进入支付界面
let AnalyticsForgotPasswordFail: String = "forgot_password_fail" // 找回密码失败
let AnalyticsForgotPasswordSucceed: String = "forgot_password_succeed" // 找回密码成功
let AnalyticsLogin: String = "log_in" // 登录
let AnalyticsLogout: String = "log_out" // 登出
let AnalyticsPaymentFail: String = "payment_fail" // 支付失败
let AnalyticsPaymentSucceed: String = "payment_succeed" // 支付成功
let AnalyticsRegisterFail: String = "register_fail" // 注册失败
let AnalyticsRegisterSucceed: String = "register_succeed" // 注册成功

