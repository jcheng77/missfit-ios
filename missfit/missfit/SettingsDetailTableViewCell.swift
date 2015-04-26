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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
