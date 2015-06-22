//
//  FeaturedClassTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 6/17/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class FeaturedClassTableViewCell: UITableViewCell {
    @IBOutlet weak var classImage: UIImageView!
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var locatingImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(missfitClass: MissFitClass) {
        className.text = missfitClass.name
        date.text = missfitClass.schedule.date
        price.text = missfitClass.price?.stringValue
        if let distanceString = missfitClass.distance {
            distance.text = distanceString
            locatingImage.hidden = false
        } else {
            distance.text = nil
            locatingImage.hidden = true
        }
        if MissFitUser.user.hasMonthlyCard && !MissFitUser.user.isMonthlyCardExpired() {
            price.text = missfitClass.memberPrice?.stringValue
        }
        classImage.image = nil
        if let classImageUrl = missfitClass.location.picUrl {
            classImage.setImageWithURL(NSURL(string: classImageUrl))
        }
    }
}