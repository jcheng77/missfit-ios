//
//  ClassDetailTargetUsersTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 6/27/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class ClassDetailTargetUsersTableViewCell: UITableViewCell {

    @IBOutlet weak var targetUsers: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(missfitClass: MissFitClass) {
        targetUsers.text = missfitClass.target
    }

}
