//
//  ClassDetailPriceTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 6/27/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class ClassDetailPriceTableViewCell: UITableViewCell {

    @IBOutlet weak var memberPrice: UILabel!
    @IBOutlet weak var nonMemberPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(missfitClass: MissFitClass) {
        if missfitClass.memberPrice?.floatValue == 0 {
            self.memberPrice.text = "免费"
        } else {
            self.memberPrice.text = "¥ " + missfitClass.memberPrice!.stringValue
        }
        
        if missfitClass.price?.floatValue == 0 {
            self.nonMemberPrice.text = "免费"
        } else {
            self.nonMemberPrice.text = "¥ " + missfitClass.price!.stringValue
        }
    }

}
