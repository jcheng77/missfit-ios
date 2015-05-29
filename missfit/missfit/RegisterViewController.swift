//
//  RegisterViewController.swift
//  missfit
//
//  Created by Hank Liang on 4/15/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var verifycodeButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passcodeTextField: UITextField!
    @IBOutlet weak var verifyCodeTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    var timer: NSTimer?
    let maxTimerSeconds = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.phoneNumberTextField.layer.borderWidth = 1.0
        self.phoneNumberTextField.layer.borderColor = MissFitTheme.theme.colorTextFieldBorder.CGColor
        self.passcodeTextField.layer.borderWidth = 1.0
        self.passcodeTextField.layer.borderColor = MissFitTheme.theme.colorTextFieldBorder.CGColor
        self.verifyCodeTextField.layer.borderWidth = 1.0
        self.verifyCodeTextField.layer.borderColor = MissFitTheme.theme.colorTextFieldBorder.CGColor
        self.nameTextField.layer.borderWidth = 1.0
        self.nameTextField.layer.borderColor = MissFitTheme.theme.colorTextFieldBorder.CGColor
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        phoneNumberTextField.resignFirstResponder()
        passcodeTextField.resignFirstResponder()
        verifyCodeTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
    }
    
    func keyboardWillShow(notifiction: NSNotification) {
        var keyboardEndFrame: CGRect = CGRectZero
        (notifiction.userInfo! as NSDictionary).valueForKey(UIKeyboardFrameEndUserInfoKey)!.getValue(&keyboardEndFrame)
        let keyboardHeight: CGFloat = keyboardEndFrame.size.height
        let buttonBottomPointY = submitButton.frame.origin.y + submitButton.frame.size.height
        let keyboardTopPointY = self.view.frame.size.height - keyboardHeight
        let offsetY = keyboardTopPointY - buttonBottomPointY
        let oldFrame = self.view.frame
        self.view.frame = CGRectMake(oldFrame.origin.x, min(offsetY, 0.0), oldFrame.size.width, oldFrame.size.height)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let oldFrame = self.view.frame
        self.view.frame = CGRectMake(oldFrame.origin.x, 0, oldFrame.size.width, oldFrame.size.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
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
        self.hideKeyboard(self)
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
                    var name: String = self.nameTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    if name == "" {
                        KVNProgress.showErrorWithStatus("姓名不能为空")
                    } else {
                        var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
                        var endpoint: String = MissFitBaseURL + MissFitRegisterURI
                        var code: Int = verifyCode.toInt()!
                        var parameters = ["username": phoneNumber, "password": passcode, "code": code, "name": name]
                        KVNProgress.show()
                        manager.POST(endpoint, parameters: parameters, success: { (operation, responseObject) -> Void in
                            self.dismissViewControllerAnimated(true, completion: nil)
                            KVNProgress.showSuccessWithStatus("恭喜您注册成功！")
                            //注册成功
                            }, failure: { (operation, error) -> Void in
                                //注册失败
                                if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                                    // Need to get the status and message
                                    let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData)
                                    let message: String? = json["message"].string
                                    KVNProgress.showErrorWithStatus(message)
                                } else {
                                    KVNProgress.showErrorWithStatus("注册失败")
                                }
                        })
                    }
                }
            }
        } else {
            KVNProgress.showErrorWithStatus("请填写正确的手机号码！")
        }
    }
    
    @IBAction func verifyCodeButtonClicked(sender: AnyObject) {
        var regex: NSRegularExpression = NSRegularExpression(pattern: "(\\d{11})", options: NSRegularExpressionOptions.CaseInsensitive, error: nil)!
        let result = regex.firstMatchInString(self.phoneNumberTextField.text!, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, count(self.phoneNumberTextField.text!.utf16)))
        
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if self.phoneNumberTextField.isFirstResponder() {
            self.phoneNumberTextField.layer.borderColor = MissFitTheme.theme.colorPink.CGColor
            self.passcodeTextField.layer.borderColor = MissFitTheme.theme.colorTextFieldBorder.CGColor
            self.verifyCodeTextField.layer.borderColor = MissFitTheme.theme.colorTextFieldBorder.CGColor
            self.nameTextField.layer.borderColor = MissFitTheme.theme.colorTextFieldBorder.CGColor
        }
        
        if self.passcodeTextField.isFirstResponder() {
            self.phoneNumberTextField.layer.borderColor = MissFitTheme.theme.colorTextFieldBorder.CGColor
            self.passcodeTextField.layer.borderColor = MissFitTheme.theme.colorPink.CGColor
            self.verifyCodeTextField.layer.borderColor = MissFitTheme.theme.colorTextFieldBorder.CGColor
            self.nameTextField.layer.borderColor = MissFitTheme.theme.colorTextFieldBorder.CGColor
        }
        
        if self.verifyCodeTextField.isFirstResponder() {
            self.phoneNumberTextField.layer.borderColor = MissFitTheme.theme.colorTextFieldBorder.CGColor
            self.passcodeTextField.layer.borderColor = MissFitTheme.theme.colorTextFieldBorder.CGColor
            self.verifyCodeTextField.layer.borderColor = MissFitTheme.theme.colorPink.CGColor
            self.nameTextField.layer.borderColor = MissFitTheme.theme.colorTextFieldBorder.CGColor
        }
        
        if self.nameTextField.isFirstResponder() {
            self.phoneNumberTextField.layer.borderColor = MissFitTheme.theme.colorTextFieldBorder.CGColor
            self.passcodeTextField.layer.borderColor = MissFitTheme.theme.colorTextFieldBorder.CGColor
            self.verifyCodeTextField.layer.borderColor = MissFitTheme.theme.colorTextFieldBorder.CGColor
            self.nameTextField.layer.borderColor = MissFitTheme.theme.colorPink.CGColor
        }
    }

}
