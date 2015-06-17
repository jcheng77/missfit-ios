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
        locatingImage.image = UIImage(named: "locating")?.imageWithRenderingMode(.AlwaysTemplate)
        locatingImage.tintColor = UIColor.whiteColor()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(missfitClass: MissFitClass) {
        
    }
}