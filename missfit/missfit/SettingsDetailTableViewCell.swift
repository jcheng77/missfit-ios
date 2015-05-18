//
//  SettingsDetailTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 4/26/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class SettingsDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var lineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var status: UILabel!

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
