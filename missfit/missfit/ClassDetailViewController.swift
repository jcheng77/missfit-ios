//
//  ClassDetailViewController.swift
//  missfit
//
//  Created by Hank Liang on 4/20/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

enum ClassDetailCellIndex: Int {
    case ClassDetailImageCell = 0, ClassDetailBookCell, ClassDetailInfoCell
}

class ClassDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let kRowNumber = 3
    let classCoverImageAspectRatio: CGFloat = 488.0 / 640.0
    var missfitClass: MissFitClass?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kRowNumber
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case ClassDetailCellIndex.ClassDetailImageCell.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("ClassDetailImageTableViewCell", forIndexPath: indexPath) as ClassDetailImageTableViewCell
            cell.setData(missfitClass!)
            return cell
        case ClassDetailCellIndex.ClassDetailBookCell.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("ClassDetailBookTableViewCell", forIndexPath: indexPath) as ClassDetailBookTableViewCell
            return cell
        case ClassDetailCellIndex.ClassDetailInfoCell.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("ClassDetailInfoTableViewCell", forIndexPath: indexPath) as ClassDetailInfoTableViewCell
            cell.setData(missfitClass!)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case ClassDetailCellIndex.ClassDetailImageCell.rawValue:
            return MissFitUtils.shortestScreenWidth() * classCoverImageAspectRatio
        case ClassDetailCellIndex.ClassDetailBookCell.rawValue:
            return 44.0
        case ClassDetailCellIndex.ClassDetailInfoCell.rawValue:
            return UITableViewAutomaticDimension
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == ClassDetailCellIndex.ClassDetailInfoCell.rawValue {
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        } else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }

}
