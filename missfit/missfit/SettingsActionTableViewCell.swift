//
//  SettingsActionTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 4/26/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class SettingsActionTableViewCell: UITableViewCell {
    @IBOutlet weak var dialButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dialButton.layer.borderWidth = 1.0
        dialButton.layer.borderColor = MissFitTheme.theme.colorPink.CGColor
        dialButton.layer.cornerRadius = 5.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
