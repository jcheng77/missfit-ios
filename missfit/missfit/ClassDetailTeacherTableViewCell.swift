//
//  ClassDetailTeacherTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 6/27/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class ClassDetailTeacherTableViewCell: UITableViewCell {
    @IBOutlet weak var teacherAvatar: UIImageView!
    @IBOutlet weak var certificationIcon: UIImageView!
    @IBOutlet weak var name: UILabel!

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
    
    func setData(missfitClass: MissFitClass) {
        name.text = missfitClass.teacher.name
        certificationIcon.hidden = !missfitClass.teacher.idVerified
        if let avatarUrl = missfitClass.teacher.avatarUrl {
            teacherAvatar.setImageWithURL(NSURL(string: avatarUrl))
        }
    }

}
