//
//  ForgotPasscodeViewController.swift
//  missfit
//
//  Created by Hank Liang on 4/24/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class ForgotPasscodeViewController: RegisterViewController {

    @IBAction override func submitButtonClicked(sender: AnyObject) {
        var regex: NSRegularExpression = NSRegularExpression(pattern: "(\\d{11})", options: NSRegularExpressionOptions.CaseInsensitive, error: nil)!
        let result = regex.firstMatchInString(self.phoneNumberTextField.text!, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, count(self.phoneNumberTextField.text!.utf16)))
        
        if result != nil && !NSEqualRanges(result!.range, NSMakeRange(NSNotFound, 0)) {
            let phoneNumber: String = (self.phoneNumberTextField.text! as NSString).substringWithRange(result!.rangeAtIndex(1))
            
            var verifyCode: String = self.verifyCodeTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            if verifyCode == "" {
                KVNProgress.showErrorWithStatus("验证码不能为空")
            } else {
                var passcode: String = self.passcodeTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                if passcode == "" {
                    KVNProgress.showErrorWithStatus("密码不能为空")
                } else {
                    var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
                    var endpoint: String = MissFitBaseURL + MissFitResetURI
                    var code: Int = verifyCode.toInt()!
                    var parameters = ["user": phoneNumber, "password": passcode, "code": code]
                    KVNProgress.show()
                    manager.POST(endpoint, parameters: parameters, success: { (operation, responseObject) -> Void in
                        KVNProgress.showSuccessWithStatus("重置密码成功！")
                        //注册成功
                        }, failure: { (operation, error) -> Void in
                            //注册失败
                            if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                                // Need to get the status and message
                                let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData)
                                let message: String? = json["message"].string
                                KVNProgress.showErrorWithStatus(message)
                            } else {
                                KVNProgress.showErrorWithStatus("重置密码失败")
                            }
                    })
                }
            }
        } else {
            KVNProgress.showErrorWithStatus("请填写正确的手机号码！")
        }
    }

}
