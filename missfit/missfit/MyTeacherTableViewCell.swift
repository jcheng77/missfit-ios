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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        teacherAvatar.layer.masksToBounds = true
        teacherAvatar.layer.cornerRadius = teacherAvatar.bounds.size.width / 2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(bookingTeacher: MissFitBookingTeacher) {
        date.text = bookingTeacher.detail.expectedDate
        address.text = bookingTeacher.detail.address
        if let avatarUrl = bookingTeacher.teacherAvatar {
            teacherAvatar.setImageWithURL(NSURL(string: avatarUrl))
        }
        teacherName.text = bookingTeacher.teacherName
    }

}
