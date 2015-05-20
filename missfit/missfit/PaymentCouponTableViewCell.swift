//
//  PaymentCouponTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 5/19/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class PaymentCouponTableViewCell: UITableViewCell {
    @IBOutlet weak var coupon: UILabel!
    @IBOutlet weak var currencySymbol: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
