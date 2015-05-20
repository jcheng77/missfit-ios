//
//  PaymentActionTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 5/19/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class PaymentActionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var alipayCheckboxBackground: UIView!
    @IBOutlet weak var alipayCheckboxForeground: UIView!
    @IBOutlet weak var wepayCheckboxBackground: UIView!
    @IBOutlet weak var wepayCheckboxForeground: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func alipayButtonClicked(sender: AnyObject)  {
        println("call alipayButtonClicked in PaymentActionTableViewCell")
    }
    
    @IBAction func wepayButtonClicked(sender: AnyObject) {
    }
}
