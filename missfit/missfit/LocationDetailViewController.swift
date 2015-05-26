//
//  LocationDetailViewController.swift
//  missfit
//
//  Created by Hank Liang on 4/20/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

enum LocationCategory {
    case Info
    case Class
}

enum LocationDetailCellIndex: Int {
    case LocationDetailImageCell = 0, LocationDetailMapCell
}

class LocationDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let kRowNumber = 2
    let locationCoverImageAspectRatio: CGFloat = 488.0 / 640.0
    var missfitLocation: MissFitLocation?
    var currentCategory = LocationCategory.Info
    var scene: WXScene = WXSceneSession

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initSegments()
        
        if WXApi.isWXAppInstalled() && WXApi.isWXAppSupportApi() {
            // do nothing
        } else {
            navigationItem.rightBarButtonItem = nil
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func sendLocationInfo() {
        let message = WXMediaMessage()
        message.title = "美人瑜 - " + self.missfitLocation!.name
        message.description = "你身边的瑜伽健身教练"
        message.setThumbImage(UIImage(named: "logo"))
        
        let ext = WXWebpageObject()
        ext.webpageUrl = MissFitSharingClassURI + self.missfitLocation!.locationId
        
        message.mediaObject = ext;
        message.mediaTagName = "WECHAT_TAG_JUMP_SHOWRANK"
        
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(self.scene.value)
        WXApi.sendReq(req)
    }
    
    @IBAction func actionButtonClicked(sender: AnyObject) {
        let sheet = UIAlertController(title: "推荐好友", message: nil, preferredStyle: .ActionSheet)
        let wxFriendAction = UIAlertAction(title: "微信好友", style: .Default) { (action: UIAlertAction!) -> Void in
            self.scene = WXSceneSession
            self.sendLocationInfo()
        }
        
        let wxTimelineAction = UIAlertAction(title: "微信朋友圈", style: .Default) { (action: UIAlertAction!) -> Void in
            self.scene = WXSceneTimeline
            self.sendLocationInfo()
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel) { (action: UIAlertAction!) -> Void in
            // Do nothing
        }
        
        sheet.addAction(wxFriendAction)
        sheet.addAction(wxTimelineAction)
        sheet.addAction(cancelAction)
        
        presentViewController(sheet, animated: true, completion: nil)
        
    }
    
    func toggleSelection(sender: AnyObject) {
        let segmentedControl = sender as! UISegmentedControl
        if segmentedControl.selectedSegmentIndex == 0 {
            currentCategory = LocationCategory.Info
            containerView.hidden = true
            tableView.hidden = false
        } else {
            currentCategory = LocationCategory.Class
            containerView.hidden = false
            tableView.hidden = true
        }
        
        tableView.reloadData()
    }
    
    func initSegments() {
        let optionsArray = ["分店信息", "分店课表"]
        let optionsToggle = UISegmentedControl(items: optionsArray)
        optionsToggle.addTarget(self, action: Selector("toggleSelection:"), forControlEvents: UIControlEvents.ValueChanged)
        optionsToggle.selectedSegmentIndex = 0
        self.navigationItem.titleView = optionsToggle
        containerView.hidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LocationToClass" {
            (segue.destinationViewController as! LocationClassesViewController).missfitLocation = self.missfitLocation
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kRowNumber
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case LocationDetailCellIndex.LocationDetailImageCell.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("LocationDetailImageTableViewCell", forIndexPath: indexPath) as! LocationDetailImageTableViewCell
            cell.setData(missfitLocation!)
            return cell
        case LocationDetailCellIndex.LocationDetailMapCell.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("LocationDetailInfoTableViewCell", forIndexPath: indexPath) as! LocationDetailInfoTableViewCell
            cell.setData(missfitLocation!)
            return cell
        default:
            return UITableViewCell()
        }
    }

}
