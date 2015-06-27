//
//  CommentSectionTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 6/22/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class CommentSectionTableViewCell: UITableViewCell {
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var lineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var noComments: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        line.backgroundColor = MissFitTheme.theme.colorSeperator
        lineHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
        errorMessage.hidden = true
        noComments.hidden = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}