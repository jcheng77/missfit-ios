//
//  TeacherInfoCreationViewController.swift
//  missfit
//
//  Created by Hank Liang on 8/16/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class TeacherInfoCreationViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var personalDescription: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let leftConstraint = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0)
        self.view.addConstraint(leftConstraint)
        let rightConstraint = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0)
        self.view.addConstraint(rightConstraint)
        
        self.personalDescription.layer.borderWidth = 1.0
        self.personalDescription.layer.borderColor = MissFitTheme.theme.colorTextFieldBorder.CGColor
        
        let tapGesture = UIGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
        self.contentView.addGestureRecognizer(tapGesture)
    }
    
    func dismissKeyboard() {
        
    }

}
