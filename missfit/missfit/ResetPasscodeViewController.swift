//
//  ResetPasscodeViewController.swift
//  missfit
//
//  Created by Hank Liang on 4/15/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class ResetPasscodeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBOutlet weak var verifycodeButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passcodeTextField: UITextField!
    @IBOutlet weak var verifyCodeTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    var timer: NSTimer?
    let maxTimerSeconds = 20
    
    func updateVerifyCodeButtonTimer() {
        let remainingSeconds = verifycodeButton.titleForState(.Disabled)!.toInt()! - 1
        if remainingSeconds > 0 {
            verifycodeButton.setTitle(String(remainingSeconds), forState: .Disabled)
        } else {
            timer!.invalidate()
            timer = nil
            updateVerifyCodeButton(true)
        }
    }
    
    func updateVerifyCodeButton(enabled: Bool) {
        if enabled {
            verifycodeButton.enabled = true
            verifycodeButton.setTitle("获取验证码", forState: .Normal)
            verifycodeButton.backgroundColor = MissFitTheme.theme.colorPink
        } else {
            verifycodeButton.enabled = false
            verifycodeButton.setTitle(String(maxTimerSeconds), forState: .Disabled)
            verifycodeButton.backgroundColor = MissFitTheme.theme.colorDisabled
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateVerifyCodeButtonTimer"), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func submitButtonClicked(sender: AnyObject) {
        var regex: NSRegularExpression = NSRegularExpression(pattern: "(\\d{11})", options: NSRegularExpressionOptions.CaseInsensitive, error: nil)!
        let result = regex.firstMatchInString(self.phoneNumberTextField.text!, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.phoneNumberTextField.text!.utf16Count))
        
        if result != nil && !NSEqualRanges(result!.range, NSMakeRange(NSNotFound, 0)) {
            let phoneNumber: String = (self.phoneNumberTextField.text! as NSString).substringWithRange(result!.rangeAtIndex(1))

            var passcode: String = self.passcodeTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            if passcode == "" {
                KVNProgress.showErrorWithStatus("密码不能为空")
            } else {
                var verifyCode: String = self.verifyCodeTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                if verifyCode == "" {
                    KVNProgress.showErrorWithStatus("验证码不能为空")
                } else {
                    var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
                    var endpoint: String = MissFitBaseURL + MissFitResetURI
                    var code: Int = verifyCode.toInt()!
                    var parameters = ["user": phoneNumber, "password": passcode, "code": code, "profile": ["mobile": phoneNumber]]
                    KVNProgress.show()
                    manager.POST(endpoint, parameters: parameters, success: { (operation, responseObject) -> Void in
                        KVNProgress.showSuccessWithStatus("重置密码成功！")
                        //注册成功
                    }, failure: { (operation, error) -> Void in
                        //注册失败
                        if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                            // Need to get the status and message
                            let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as NSData)
                            let message: String? = json["message"].string
                            KVNProgress.showErrorWithStatus(message?)
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
    
    @IBAction func verifyCodeButtonClicked(sender: AnyObject) {
        var regex: NSRegularExpression = NSRegularExpression(pattern: "(\\d{11})", options: NSRegularExpressionOptions.CaseInsensitive, error: nil)!
        let result = regex.firstMatchInString(self.phoneNumberTextField.text!, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.phoneNumberTextField.text!.utf16Count))
        
        if result != nil && !NSEqualRanges(result!.range, NSMakeRange(NSNotFound, 0)) {
            let phoneNumber: String = (self.phoneNumberTextField.text! as NSString).substringWithRange(result!.rangeAtIndex(1))
            var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
            var endpoint: String = MissFitBaseURL + MissFitVerifyCodeURI + phoneNumber
            manager.POST(endpoint, parameters: nil, success: { (operation, responseObject) -> Void in
                //验证码获取成功
                self.updateVerifyCodeButton(false)
            }, failure: { (operation, error) -> Void in
                //验证码获取失败
            })
        } else {
            KVNProgress.showErrorWithStatus("请填写正确的手机号码！")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
