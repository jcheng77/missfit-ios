//
//  MyTeacherTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 5/13/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class MyTeacherTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var teacherAvatar: UIImageView!
    @IBOutlet weak var teacherName: UILabel!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var lineHeightConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        teacherAvatar.layer.masksToBounds = true
        teacherAvatar.layer.cornerRadius = teacherAvatar.bounds.size.width / 2
        line.backgroundColor = MissFitTheme.theme.colorSeperator
        lineHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(bookingTeacher: MissFitBookingTeacher) {
        if bookingTeacher.detail.expectedDate != nil {
            date.text = MissFitUtils.formatDate(MissFitUtils.dateFromString(bookingTeacher.detail.expectedDate!))
        }
        address.text = bookingTeacher.detail.address
        teacherAvatar.image = nil
        if let avatarUrl = bookingTeacher.teacherAvatar {
            teacherAvatar.setImageWithURL(NSURL(string: avatarUrl), placeholderImage: UIImage(named: "default-teacher-avatar"))
        }
        teacherName.text = bookingTeacher.teacherName
    }

}
