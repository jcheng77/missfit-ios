//
//  TeacherTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 4/20/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//


class TeacherTableViewCell: UITableViewCell {

    @IBOutlet weak var teacherImage: UIImageView!
    @IBOutlet weak var teacherAvatar: UIImageView!
    @IBOutlet weak var verifiedIcon: UIImageView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var teacherName: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var chartsIcon: UIImageView!
    @IBOutlet weak var charts: UILabel!
    @IBOutlet weak var commentsIcon: UIImageView!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var likesIcon: UIImageView!
    @IBOutlet weak var likes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        teacherAvatar.layer.masksToBounds = true
        teacherAvatar.layer.cornerRadius = teacherAvatar.bounds.size.width / 2
        chartsIcon.hidden = true
        charts.hidden = true
        commentsIcon.hidden = true
        comments.hidden = true
        likesIcon.hidden = true
        likes.hidden = true
    }
    
    func setData(teacher: MissFitTeacher) {
        if let coverPicUrl = teacher.coverPicUrl {
            teacherImage.setImageWithURL(NSURL(string: coverPicUrl))
        }
        
        if let avatarUrl = teacher.avatarUrl {
            teacherAvatar.setImageWithURL(NSURL(string: avatarUrl))
        }
        
        verifiedIcon.hidden = !teacher.idVerified
        address.text = teacher.address
        teacherName.text = teacher.name
        
        if let distanceString = teacher.distance {
            distance.text = distanceString + " km"
            distance.hidden = false
        } else {
            distance.hidden = true
        }
    }
}
