//
//  TeacherBookingViewController.swift
//  missfit
//
//  Created by Hank Liang on 5/11/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class TeacherBookingViewController: UIViewController {
    var teacherInfo: MissFitTeacher?
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var submitButton: UIButton!
   
    @IBAction func submitButtonClicked(sender: AnyObject) {
        // Validate the text fields.
        var regex: NSRegularExpression = NSRegularExpression(pattern: "(\\d{11})", options: NSRegularExpressionOptions.CaseInsensitive, error: nil)!
        let result = regex.firstMatchInString(self.phone.text!, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.phone.text!.utf16Count))
        
        if result != nil && !NSEqualRanges(result!.range, NSMakeRange(NSNotFound, 0)) {
            let phoneNumber: String = (self.phone.text! as NSString).substringWithRange(result!.rangeAtIndex(1))
            
            var nameString: String = self.name.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            if nameString == "" {
                KVNProgress.showErrorWithStatus("姓名不能为空")
            } else {
                var addressString: String = self.address.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                if addressString == "" {
                    KVNProgress.showErrorWithStatus("地址不能为空")
                } else {
                    var dateString = self.date.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    if dateString == "" {
                        KVNProgress.showErrorWithStatus("日期不能为空")
                    } else {
                        var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
                        var endpoint: String = MissFitBaseURL + MissFitTeachersURI + "/" + self.teacherInfo!.teacherId + MissFitClassesBookingURI
                        var parameters = ["details": ["date": dateString, "name": nameString, "phone": phoneNumber, "address": addressString]]
                        
                        KVNProgress.show()
                        self.hideKeyboard(self)
                        manager.requestSerializer.setValue(MissFitUser.user.userId, forHTTPHeaderField: "X-User-Id")
                        manager.requestSerializer.setValue(MissFitUser.user.token, forHTTPHeaderField: "X-Auth-Token")
                        manager.POST(endpoint, parameters: parameters, success: { (operation, responseObject) -> Void in
                            KVNProgress.showSuccessWithStatus("预约成功")
                            self.dismissViewControllerAnimated(true, completion: nil)
                            }) { (operation, error) -> Void in
                                if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                                    // Need to get the status and message
                                    let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as NSData)
                                    let message: String? = json["message"].string
                                    KVNProgress.showErrorWithStatus(message?)
                                } else {
                                    KVNProgress.showErrorWithStatus("预约失败")
                                }
                        }
                    }
                }
            }
        } else {
            KVNProgress.showErrorWithStatus("请填写正确的手机号码！")
        }
    }
    
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        phone.resignFirstResponder()
        name.resignFirstResponder()
        address.resignFirstResponder()
        date.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.removeFromSuperview()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        //TODO: use the date picker to select the date
//        self.date.inputView = self.datePicker
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
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
