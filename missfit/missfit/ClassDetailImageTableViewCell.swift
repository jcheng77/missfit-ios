//
//  ClassDetailImageTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 4/22/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class ClassDetailImageTableViewCell: UITableViewCell {

    @IBOutlet weak var classImage: UIImageView!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var classDate: UILabel!
    @IBOutlet weak var classTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(missfitClass: MissFitClass) {
        className.text = missfitClass.name
        classDate.text = missfitClass.schedule.date
        classTime.text = missfitClass.schedule.startTime
        locationName.text = missfitClass.location.name
        address.text = missfitClass.location.address
        if let classImageUrl = missfitClass.location.picUrl {
            classImage.setImageWithURL(NSURL(string: classImageUrl))
        }
    }

}
