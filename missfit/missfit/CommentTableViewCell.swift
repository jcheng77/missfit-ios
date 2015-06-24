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
    let kRateViewTag = 555

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commentIcon.layer.masksToBounds = true
        commentIcon.layer.cornerRadius = commentIcon.bounds.size.width / 2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(missfitComment: MissFitComment) {
        self.commentName.text = missfitComment.userName
        self.commentDate.text = missfitComment.date
        self.commentIcon.image = UIImage(named: "default-avatar")
        if let urlString = missfitComment.userIcon {
            self.commentIcon.setImageWithURL(NSURL(string: urlString), placeholderImage:UIImage(named: "default-avatar"))
        }
        
        self.commentIcon.superview?.viewWithTag(kRateViewTag)?.removeFromSuperview()
        if let currentScore = missfitComment.score {
            let rateView = DYRateView(frame: CGRectMake(78, 28, 160, 16))
            rateView.fullStarImage = UIImage(named: "star-small")
            rateView.emptyStarImage = UIImage(named: "star-gray-small")
            rateView.rate = CGFloat(currentScore)
            rateView.alignment = RateViewAlignmentLeft
            rateView.tag = kRateViewTag
            self.commentIcon.superview?.addSubview(rateView)
        }
        
        self.commentContent.text = missfitComment.content
    }
}
