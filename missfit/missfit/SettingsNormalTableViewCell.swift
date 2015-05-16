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
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var lineHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        line.backgroundColor = MissFitTheme.theme.colorSeperator
        lineHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
