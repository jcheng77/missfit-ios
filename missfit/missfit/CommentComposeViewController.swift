//
//  CommentComposeViewController.swift
//  missfit
//
//  Created by Hank Liang on 6/23/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

protocol CommentComposeViewControllerDelegate {
    func commentPostSucceeded()
}

class CommentComposeViewController: UIViewController, UITextViewDelegate {
    var teacher: MissFitTeacher?
    var delegate: CommentComposeViewControllerDelegate?
    var currentScore: Int = 4
    
    @IBAction func cancelButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func composeButtonClicked(sender: AnyObject) {
        if content.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
            KVNProgress.showErrorWithStatus("内容不能为空")
        } else {
            var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
            var endpoint: String = MissFitBaseURL + MissFitTeachersURI + "/" + teacher!.teacherId + "/" + MissFitCommentsURI
            var parameters = ["content": content.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()), "score": currentScore]
            manager.requestSerializer.setValue(MissFitUser.user.userId, forHTTPHeaderField: "X-User-Id")
            manager.requestSerializer.setValue(MissFitUser.user.token, forHTTPHeaderField: "X-Auth-Token")
            KVNProgress.show()
            manager.POST(endpoint, parameters: parameters, success: { (operation, responseObject) -> Void in
                KVNProgress.showSuccessWithStatus("发表成功")
                self.delegate?.commentPostSucceeded()
                self.dismissViewControllerAnimated(true, completion: nil)
                }, failure: { (operation, error) -> Void in
                    if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                        // Need to get the status and message
                        let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData)
                        let message: String? = json["message"].string
                        KVNProgress.showErrorWithStatus(message)
                    } else {
                        KVNProgress.showErrorWithStatus("发表失败")
                    }
            })
        }
    }

    @IBOutlet weak var rateSection: UIView!
    @IBOutlet weak var commentTitle: UILabel!
    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var content: UITextView!
    
    func setUpEditableRateView() {
        let rateView = DYRateView(frame: CGRectMake(50, 25, self.view.bounds.size.width, 25))
        rateView.padding = 20
        rateView.alignment = RateViewAlignmentLeft;
        rateView.editable = true;
        rateView.delegate = self;
        rateView.rate = CGFloat(currentScore)
        self.rateSection.addSubview(rateView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
        commentTitle.text = teacher?.name
        content.becomeFirstResponder()
        setUpEditableRateView()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var keyboardEndFrame: CGRect = CGRectZero
        (notification.userInfo! as NSDictionary).valueForKey(UIKeyboardFrameEndUserInfoKey)!.getValue(&keyboardEndFrame)
        let keyboardHeight: CGFloat = keyboardEndFrame.size.height
        
        let oldFrame = self.content.frame
        let viewFrame = self.view.frame
        self.content.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.width, viewFrame.height - oldFrame.origin.y - keyboardHeight)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var keyboardEndFrame: CGRect = CGRectZero
        (notification.userInfo! as NSDictionary).valueForKey(UIKeyboardFrameEndUserInfoKey)!.getValue(&keyboardEndFrame)
        let keyboardHeight: CGFloat = keyboardEndFrame.size.height
        
        let oldFrame = self.content.frame
        let viewFrame = self.view.frame
        self.content.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, viewFrame.height - oldFrame.origin.y)
    }
    
    func textViewDidChange(textView: UITextView) {
        if textView.text == "" {
            self.placeholder.hidden = false
        } else {
            self.placeholder.hidden = true
        }
    }
    
    // MARK: - DYRateViewDelegate
    func rateView(rateView: DYRateView, changedToNewRate rate: NSNumber) {
        currentScore = rate.integerValue
    }
}
