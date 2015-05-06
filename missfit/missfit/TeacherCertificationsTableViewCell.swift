//
//  TeacherCertificationsTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 4/30/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class TeacherCertificationsTableViewCell: UITableViewCell {
    @IBOutlet weak var certifiedType1: UILabel!
    @IBOutlet weak var certifiedTypeIcon1: UIImageView!
    @IBOutlet weak var certifiedType2: UILabel!
    @IBOutlet weak var certifiedTypeIcon2: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
