//
//  PaymentContentTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 5/19/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class PaymentContentTableViewCell: UITableViewCell {
    @IBOutlet weak var validThroughLabel: UILabel!
    @IBOutlet weak var validThrough: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var needToPay: UILabel!
    @IBOutlet weak var feeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
