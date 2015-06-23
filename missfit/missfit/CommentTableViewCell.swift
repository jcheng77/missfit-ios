//
//  CommentTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 6/22/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var commentIcon: UIImageView!
    @IBOutlet weak var commentName: UILabel!
    @IBOutlet weak var commentDate: UILabel!
    @IBOutlet weak var commentContent: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(missfitComment: MissFitComment) {
        self.commentName.text = missfitComment.userName
        self.commentDate.text = missfitComment.date
        self.commentIcon.image = nil
        if let urlString = missfitComment.userIcon {
            self.commentIcon.setImageWithURL(NSURL(string: urlString))
        }
    }
}
