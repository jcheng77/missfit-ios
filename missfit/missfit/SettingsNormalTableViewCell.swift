//
//  SettingsNormalTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 4/26/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class SettingsNormalTableViewCell: UITableViewCell {

    @IBOutlet weak var key: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var seperator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
