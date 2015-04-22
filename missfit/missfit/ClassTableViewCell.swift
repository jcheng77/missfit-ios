//
//  ClassTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 4/22/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class ClassTableViewCell: UITableViewCell {

    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var area: UILabel!
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
    
    func setData(missfitClass: MissFitClass) {
        startTime.text = missfitClass.schedule.startTime
        name.text = missfitClass.name
        duration.text = String("\(missfitClass.schedule.duration)分钟")
        address.text = missfitClass.location.address
        area.text = missfitClass.location.area
        if let avatarUrl = missfitClass.teacher.avatarUrl {
            teacherAvatar.setImageWithURL(NSURL(string: avatarUrl))
        }
        teacherName.text = missfitClass.teacher.name
    }

}
