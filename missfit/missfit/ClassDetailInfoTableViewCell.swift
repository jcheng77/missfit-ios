//
//  ClassDetailInfoTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 4/22/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class ClassDetailInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var classInstrucationContent: UILabel!
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
        classInstrucationContent.text = missfitClass.desc
        targetUsers.text = missfitClass.target
    }
}
