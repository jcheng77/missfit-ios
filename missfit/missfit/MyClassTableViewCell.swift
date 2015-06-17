//
//  MyClassTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 5/5/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class MyClassTableViewCell: ClassTableViewCell {
    @IBOutlet weak var startDate: UILabel!
   
    override func setData(missfitClass: MissFitClass) {
        let dateString = missfitClass.schedule.date
        let startIndex = advance(dateString.startIndex, 5)
        startDate.text = dateString.substringFromIndex(startIndex)
        startTime.text = missfitClass.schedule.startTime
        name.text = missfitClass.name
        duration.text = String("\(missfitClass.schedule.duration)分钟")
        address.text = missfitClass.location.address
        area.text = missfitClass.location.area
        teacherAvatar.image = nil
        if let avatarUrl = missfitClass.teacher.avatarUrl {
            teacherAvatar.setImageWithURL(NSURL(string: avatarUrl))
            teacherAvatar.hidden = false
        } else {
            teacherAvatar.hidden = true
        }
        teacherName.text = missfitClass.teacher.name
    }
}
