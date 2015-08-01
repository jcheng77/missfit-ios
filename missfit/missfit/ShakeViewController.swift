//
//  ShakeViewController.swift
//  missfit
//
//  Created by Hank Liang on 8/1/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class ShakeViewController: UIViewController {
    @IBOutlet weak var otherTextView: UITextView!
    @IBOutlet weak var categoryLineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sexLineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var areaLineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headCountLineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var learningPhaseLineHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otherTextView.layer.borderWidth = 1.0 / UIScreen.mainScreen().scale
        otherTextView.layer.borderColor = MissFitTheme.theme.colorTextFieldBorder.CGColor
        categoryLineHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
        sexLineHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
        areaLineHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
        headCountLineHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
        learningPhaseLineHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
    }


    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func categoryClicked(sender: AnyObject) {
    }
    
    @IBAction func sexClicked(sender: AnyObject) {
    }
    
    @IBAction func areaClicked(sender: AnyObject) {
    }
    
    @IBAction func headCountClicked(sender: AnyObject) {
    }
    
    @IBAction func learningPhaseClicked(sender: AnyObject) {
    }
    
}
