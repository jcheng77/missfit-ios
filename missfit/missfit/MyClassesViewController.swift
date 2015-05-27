//
//  MyClassesViewController.swift
//  missfit
//
//  Created by Hank Liang on 5/5/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

enum MyClassCategory {
    case Class
    case Teacher
}

class MyClassesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    var classes: [MissFitClass]?
    var bookingTeachers: [MissFitBookingTeacher]?
    var currentCategory = MyClassCategory.Class
    @IBAction func backButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func toggleSelection(sender: AnyObject) {
        let segmentedControl = sender as! UISegmentedControl
        if segmentedControl.selectedSegmentIndex == 0 {
            currentCategory = MyClassCategory.Class
        } else {
            currentCategory = MyClassCategory.Teacher
        }
        
        tableView.reloadData()
        
        if classes == nil || bookingTeachers == nil {
            fetchData(currentCategory)
        }
    }
    
    func parseClassResponseObject(responseObject: NSDictionary) {
        let json = JSON(responseObject)
        for (key: String, subJson: JSON) in json {
            if key == "data" {
                for (index: String, thirdJson: JSON) in subJson {
                    let missfitClass: MissFitClass = MissFitClass(json: thirdJson)
                    classes!.append(missfitClass)
                }
            }
        }
    }
    
    func parseTeacherResponseObject(responseObject: NSDictionary) {
        let json = JSON(responseObject)
        for (key: String, subJson: JSON) in json {
            if key == "data" {
                for (index: String, thirdJson: JSON) in subJson {
                    let missfitBookingTeacher: MissFitBookingTeacher = MissFitBookingTeacher(json: thirdJson)
                    bookingTeachers!.append(missfitBookingTeacher)
                }
            }
        }
    }
    
    func fetchData(category: MyClassCategory) {
        if category == MyClassCategory.Class {
            if classes == nil {
                classes = [MissFitClass]()
            }
            classes!.removeAll(keepCapacity: false)
            var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
            var endpoint: String = MissFitBaseURL + MissFitMyClassesURI
            KVNProgress.show()
            manager.requestSerializer.setValue(MissFitUser.user.userId, forHTTPHeaderField: "X-User-Id")
            manager.requestSerializer.setValue(MissFitUser.user.token, forHTTPHeaderField: "X-Auth-Token")
            manager.GET(endpoint, parameters: nil, success: { (operation, responseObject) -> Void in
                //            KVNProgress.showSuccessWithStatus("获取课程列表成功！")
                KVNProgress.dismiss()
                // Parse data
                self.parseClassResponseObject(responseObject as! NSDictionary)
                self.tableView.reloadData()
                self.tableView.stopPullToRefresh()
                }) { (operation, error) -> Void in
                    if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                        // Need to get the status and message
                        let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData)
                        let message: String? = json["message"].string
                        KVNProgress.showErrorWithStatus(message)
                    } else {
                        KVNProgress.showErrorWithStatus("获取我的课程列表失败")
                    }
                    self.tableView.stopPullToRefresh()
            }
        } else {
            if bookingTeachers == nil {
                bookingTeachers = [MissFitBookingTeacher]()
            }
            bookingTeachers!.removeAll(keepCapacity: false)
            var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
            var endpoint: String = MissFitBaseURL + MissFitMyTeachersURI
            KVNProgress.show()
            manager.requestSerializer.setValue(MissFitUser.user.userId, forHTTPHeaderField: "X-User-Id")
            manager.requestSerializer.setValue(MissFitUser.user.token, forHTTPHeaderField: "X-Auth-Token")
            manager.GET(endpoint, parameters: nil, success: { (operation, responseObject) -> Void in
                KVNProgress.dismiss()
                // Parse data
                self.parseTeacherResponseObject(responseObject as! NSDictionary)
                self.tableView.reloadData()
                self.tableView.stopPullToRefresh()
                }) { (operation, error) -> Void in
                    if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                        // Need to get the status and message
                        let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData)
                        let message: String? = json["message"].string
                        KVNProgress.showErrorWithStatus(message)
                    } else {
                        KVNProgress.showErrorWithStatus("获取老师预约列表失败")
                    }
                    self.tableView.stopPullToRefresh()
            }
        }
    }
    
    func loadMoreData(page: Int) {
    }
    
    func initSegments() {
        let optionsArray = ["我的课程", "老师预约"]
        let optionsToggle = UISegmentedControl(items: optionsArray)
        optionsToggle.addTarget(self, action: Selector("toggleSelection:"), forControlEvents: UIControlEvents.ValueChanged)
        optionsToggle.selectedSegmentIndex = 0
        self.navigationItem.titleView = optionsToggle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSegments()
        fetchData(currentCategory)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if tableView.pullToRefreshView == nil {
            tableView.addPullToRefreshWithAction({ () -> () in
                self.fetchData(self.currentCategory)
                }, withAnimator: BeatAnimator())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentCategory == MyClassCategory.Class {
            if classes == nil {
                return 0
            } else {
                return classes!.count
            }
        } else {
            if bookingTeachers == nil {
                return 0
            } else {
                return bookingTeachers!.count
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if currentCategory == MyClassCategory.Class {
            let cell = tableView.dequeueReusableCellWithIdentifier("MyClassTableViewCell", forIndexPath: indexPath) as! MyClassTableViewCell
            cell.setData(classes![indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("MyTeacherTableViewCell", forIndexPath: indexPath) as! MyTeacherTableViewCell
            cell.setData(bookingTeachers![indexPath.row])
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 94.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if currentCategory == MyClassCategory.Class {
            let classDetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ClassDetailViewController") as! ClassDetailViewController
            classDetailController.missfitClass = classes![indexPath.row]
            classDetailController.missfitClass?.isBooked = true
            classDetailController.myClassesController = self
            navigationController?.pushViewController(classDetailController, animated: true)
        }
    }

}
