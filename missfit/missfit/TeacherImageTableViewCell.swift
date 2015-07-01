//
//  TeacherImageTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 4/30/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class TeacherImageTableViewCell: UITableViewCell, UIScrollViewDelegate {
    let aspectRatio: CGFloat = 640.0 / 718.0
    var imageArray: [String]?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.scrollView.delegate = self
        self.pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        self.pageControl.currentPageIndicatorTintColor = MissFitTheme.theme.colorPink
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(images: [String]) {
        self.imageArray = images
        let width: CGFloat = MissFitUtils.shortestScreenWidth()
        let height: CGFloat = width / aspectRatio
        
        for var i = 0; i < self.imageArray!.count; i++ {
            let subView: UIImageView = UIImageView(frame: CGRectMake(width * CGFloat(i), 0, width, height))
            subView.contentMode = .ScaleAspectFill
            subView.clipsToBounds = true
            subView.setImageWithURL(NSURL(string: self.imageArray![i]), placeholderImage: UIImage(named: "default-pic"))
            self.scrollView.addSubview(subView)
        }
        
        self.scrollView.contentSize = CGSizeMake(width * CGFloat(self.imageArray!.count), height)
        
        self.pageControl.numberOfPages = self.imageArray!.count        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = self.scrollView.frame.size.width
        let currentPage: Int = Int(floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        self.pageControl.currentPage = currentPage
    }
}
