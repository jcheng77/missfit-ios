//
//  MultiSelectionTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 8/1/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class MultiSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var checkbox: UIImageView!
    var isCheckboxOn = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
