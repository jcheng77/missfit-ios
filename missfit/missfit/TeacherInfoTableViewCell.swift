//
//  TeacherInfoTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 4/30/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class TeacherInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var verifiedIcon: UIImageView!
    @IBOutlet weak var teachScopes: UILabel!
    @IBOutlet weak var district: UILabel!
    @IBOutlet weak var area: UILabel!
    @IBOutlet weak var teachModes: UILabel!
    @IBOutlet weak var price: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
