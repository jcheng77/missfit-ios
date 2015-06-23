//
//  CommentComposeViewController.swift
//  missfit
//
//  Created by Hank Liang on 6/23/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class CommentComposeViewController: UIViewController, UITextViewDelegate {
    var teacher: MissFitTeacher?
    
    @IBAction func cancelButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func composeButtonClicked(sender: AnyObject) {
    }

    @IBOutlet weak var commentTitle: UILabel!
    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var content: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
        commentTitle.text = teacher?.name
        content.becomeFirstResponder()
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
}
