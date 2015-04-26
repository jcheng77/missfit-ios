//
//  LoginViewController.swift
//  missfit
//
//  Created by Hank Liang on 4/16/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passcodeTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var forgotPasscodeButton: UIButton!
    
    @IBAction func loginButtonClicked(sender: AnyObject) {
        var regex: NSRegularExpression = NSRegularExpression(pattern: "(\\d{11})", options: NSRegularExpressionOptions.CaseInsensitive, error: nil)!
        let result = regex.firstMatchInString(self.phoneNumberTextField.text!, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.phoneNumberTextField.text!.utf16Count))
        
        if result != nil && !NSEqualRanges(result!.range, NSMakeRange(NSNotFound, 0)) {
            let phoneNumber: String = (self.phoneNumberTextField.text! as NSString).substringWithRange(result!.rangeAtIndex(1))
            
            var passcode: String = self.passcodeTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            if passcode == "" {
                KVNProgress.showErrorWithStatus("密码不能为空")
            } else {
                var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
                var endpoint: String = MissFitBaseURL + MissFitLoginURI
                var parameters = ["user": phoneNumber, "password": passcode]
                KVNProgress.show()
                manager.POST(endpoint, parameters: parameters, success: { (operation, responseObject) -> Void in
                    KVNProgress.showSuccessWithStatus("登录成功")
                    //登录成功
                    let json = JSON(responseObject)
                    MissFitUser.user.login(json["data"]["userId"].stringValue, userPhoneNumber: phoneNumber, userToken: json["data"]["authToken"].stringValue, userPasscode: passcode)
                    self.dismissViewControllerAnimated(true, completion: nil)
                    }, failure: { (operation, error) -> Void in
                        //登录失败
                        if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                            // Need to get the status and message
                            let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as NSData)
                            let message: String? = json["message"].string
                            KVNProgress.showErrorWithStatus(message?)
                        } else {
                            KVNProgress.showErrorWithStatus("登录失败")
                        }
                })

            }
        } else {
            KVNProgress.showErrorWithStatus("请填写正确的手机号码！")
        }
    }
    
    @IBAction func registerButtonClicked(sender: AnyObject) {
        var registerViewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RegisterViewController") as UIViewController
        self.presentViewController(UINavigationController(rootViewController: registerViewController), animated: true, completion: nil)
    }
    
    @IBAction func forgotPasscodeButtonClicked(sender: AnyObject) {
        var resetPasscodeViewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ForgotPasscodeViewController") as UIViewController
        self.presentViewController(UINavigationController(rootViewController: resetPasscodeViewController), animated: true, completion: nil)
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
