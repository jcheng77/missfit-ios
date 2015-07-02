//
//  AllTeachersViewController.swift
//  missfit
//
//  Created by Hank Liang on 4/18/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit
import CoreLocation

class AllTeachersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let teacherCoverImageAspectRatio: CGFloat = 426.0 / 640.0
    
    @IBOutlet weak var tableView: UITableView!
    var teachers = [MissFitTeacher]()
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getLocationSucceeded"), name: MissFitGetLocationSucceeded, object: nil)
        self.fetchDataWithHUD()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if tableView.pullToRefreshView == nil {
            self.tableView.addPullToRefreshWithAction({ [weak self] in
                self!.fetchDataWithHUD()
                }, withAnimator: BeatAnimator())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func getLocationSucceeded() {
        self.fetchDataWithHUD()
    }
    
    func parseResponseObject(responseObject: NSDictionary) {
        let json = JSON(responseObject)
        for (key: String, subJson: JSON) in json {
            if key == "data" {
                for (index: String, thirdJson: JSON) in subJson {
                    let teacher: MissFitTeacher = MissFitTeacher(json: thirdJson)
                    teachers.append(teacher)
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
        teachers = []
        var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        var endpoint: String = MissFitBaseURL + MissFitTeachersURI
        
        if LocationManager.sharedInstance.allowUseLocation && LocationManager.sharedInstance.currentLocation != nil {
            endpoint = endpoint + "?" + MissFitLocationQueryURI + "\(LocationManager.sharedInstance.currentLocation!.coordinate.longitude),\(LocationManager.sharedInstance.currentLocation!.coordinate.latitude)"
        }
        
        KVNProgress.dismiss()
        KVNProgress.show()
        manager.GET(endpoint, parameters: nil, success: { (operation, responseObject) -> Void in
            KVNProgress.dismiss()
            // Parse data
            self.parseResponseObject(responseObject as! NSDictionary)
            self.tableView.reloadData()
            self.tableView.stopPullToRefresh()
        }) { (operation, error) -> Void in
            if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                // Need to get the status and message
                let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData)
                let message: String? = json["message"].string
                KVNProgress.showErrorWithStatus(message)
            } else {
                KVNProgress.showErrorWithStatus("获取老师列表失败")
            }
            self.tableView.stopPullToRefresh()
        }
    }
    
    func loadMoreData(page: Int) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TeacherTableViewCell", forIndexPath: indexPath) as! TeacherTableViewCell
        
        cell.setData(teachers[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0 + MissFitUtils.shortestScreenWidth() * teacherCoverImageAspectRatio
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let teacherInfo = teachers[indexPath.row]
        let teacherDetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TeacherDetailViewController") as! TeacherDetailViewController
        teacherDetailController.teacherInfo = teacherInfo
        UmengHelper.event(AnalyticsClickTeacherDetail, label: teacherInfo.name)
        navigationController?.pushViewController(teacherDetailController, animated: true)
    }
}
