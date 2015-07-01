//
//  LocationDetailImageTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 5/26/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class LocationDetailImageTableViewCell: UITableViewCell {
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var certificationImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(missfitLocation: MissFitLocation) {
        name.text = missfitLocation.name
        address.text = missfitLocation.address
        certificationImage.hidden = !missfitLocation.isVerified
        if let locationImageUrl = missfitLocation.picUrl {
            locationImage.setImageWithURL(NSURL(string: locationImageUrl), placeholderImage: UIImage(named: "default-pic"))
        }
    }

}
