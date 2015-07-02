//
//  FeaturedClassesViewController.swift
//  missfit
//
//  Created by Hank Liang on 6/17/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

enum ClassCategory {
    case Featured
    case Weekly
}

class FeaturedClassesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var currentCategory: ClassCategory = .Featured
    var classes = [MissFitClass]()
    
    func parseResponseObject(responseObject: NSDictionary) {
        let json = JSON(responseObject)
        for (key: String, subJson: JSON) in json {
            if key == "data" {
                for (index: String, thirdJson: JSON) in subJson {
                    let missfitClass: MissFitClass = MissFitClass(json: thirdJson)
                    classes.append(missfitClass)
                }
            }
        }
    }
    
    func fetchDataWithHUD() {
        if KVNProgress.isVisible() {
            KVNProgress.dismissWithCompletion({ () -> Void in
                self.fetchData()
            })
        } else {
            self.fetchData()
        }
    }
    
    func fetchData() {
        classes.removeAll(keepCapacity: false)
        var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        var endpoint: String = MissFitBaseURL + MissFitClassesURI + MissFitFeaturedClasses
        if LocationManager.sharedInstance.allowUseLocation && LocationManager.sharedInstance.currentLocation != nil {
            endpoint = endpoint + "&" + MissFitLocationQueryURI + "\(LocationManager.sharedInstance.currentLocation!.coordinate.longitude),\(LocationManager.sharedInstance.currentLocation!.coordinate.latitude)"
        }
        
        if MissFitUser.user.isLogin {
            manager.requestSerializer.setValue(MissFitUser.user.userId, forHTTPHeaderField: "X-User-Id")
            manager.requestSerializer.setValue(MissFitUser.user.token, forHTTPHeaderField: "X-Auth-Token")
        }

        KVNProgress.show()
        manager.GET(endpoint, parameters: nil, success: { (operation, responseObject) -> Void in
            //            KVNProgress.showSuccessWithStatus("获取课程列表成功！")
            KVNProgress.dismiss()
            self.tableView.stopPullToRefresh()
            // Parse data
            self.parseResponseObject(responseObject as! NSDictionary)
            self.tableView.reloadData()
            }) { (operation, error) -> Void in
                if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                    // Need to get the status and message
                    let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData)
                    let message: String? = json["message"].string
                    KVNProgress.showErrorWithStatus(message)
                } else {
                    KVNProgress.showErrorWithStatus("获取课程列表失败")
                }
                self.tableView.stopPullToRefresh()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getLocationSucceeded"), name: MissFitGetLocationSucceeded, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("loadMembershipSucceededCallback"), name: MissFitLoadMembershipSucceededCallback, object: nil)
        initSegments()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        fetchDataWithHUD()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if tableView.pullToRefreshView == nil {
            tableView.addPullToRefreshWithAction({ [weak self] in
                self!.fetchDataWithHUD()
                }, withAnimator: BeatAnimator())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLocationSucceeded() {
        if currentCategory == .Featured {
            fetchDataWithHUD()
        }
    }
    
    func loadMembershipSucceededCallback() {
        if MissFitUser.user.hasMonthlyCard && !MissFitUser.user.isMonthlyCardExpired() {
            tableView.reloadData()
        }
    }
    
    func initSegments() {
        let optionsArray = ["特色课程", "每周课程"]
        let optionsToggle = UISegmentedControl(items: optionsArray)
        optionsToggle.addTarget(self, action: Selector("toggleSelection:"), forControlEvents: UIControlEvents.ValueChanged)
        optionsToggle.selectedSegmentIndex = 0
        self.navigationItem.titleView = optionsToggle
        containerView.hidden = true
    }
    
    func toggleSelection(sender: AnyObject) {
        let segmentedControl = sender as! UISegmentedControl
        if segmentedControl.selectedSegmentIndex == 0 {
            currentCategory = ClassCategory.Featured
            containerView.hidden = true
            tableView.hidden = false
        } else {
            UmengHelper.event(AnalyticsClickWeeklyClasses)
            currentCategory = ClassCategory.Weekly
            containerView.hidden = false
            tableView.hidden = true
            NSNotificationCenter.defaultCenter().postNotificationName(MissFitLoadWeeklyClasses, object: nil)
        }
        
        tableView.reloadData()
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeaturedClassTableViewCell", forIndexPath: indexPath) as! FeaturedClassTableViewCell
        cell.setData(classes[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UmengHelper.event(AnalyticsClickClassDetail)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let classDetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ClassDetailViewController") as! ClassDetailViewController
        classDetailController.missfitClass = classes[indexPath.row]
        navigationController?.pushViewController(classDetailController, animated: true)
    }
}
