//
//  MyClassesViewController.swift
//  missfit
//
//  Created by Hank Liang on 5/5/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class MyClassesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    var classes = [MissFitClass]()
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
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
    
    func fetchData() {
        classes.removeAll(keepCapacity: false)
        var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        var endpoint: String = MissFitBaseURL + MissFitMyClassesURI
        KVNProgress.show()
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue(MissFitUser.user.userId, forHTTPHeaderField: "X-User-Id")
        manager.requestSerializer.setValue(MissFitUser.user.token, forHTTPHeaderField: "X-Auth-Token")
        println("userId:\(MissFitUser.user.userId)")
        println("token:\(MissFitUser.user.token)")
        manager.GET(endpoint, parameters: nil, success: { (operation, responseObject) -> Void in
            //            KVNProgress.showSuccessWithStatus("获取课程列表成功！")
            KVNProgress.dismiss()
            // Parse data
            self.parseResponseObject(responseObject as NSDictionary)
            self.tableView.reloadData()
            println("responseData:\(responseObject)")
            }) { (operation, error) -> Void in
                if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                    // Need to get the status and message
                    let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as NSData)
                    let message: String? = json["message"].string
                    KVNProgress.showErrorWithStatus(message?)
                } else {
                    KVNProgress.showErrorWithStatus("获取我的课程列表失败")
                }
        }
    }
    
    func loadMoreData(page: Int) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyClassTableViewCell", forIndexPath: indexPath) as MyClassTableViewCell
        cell.setData(classes[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 94.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let classDetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ClassDetailViewController") as ClassDetailViewController
        classDetailController.missfitClass = classes[indexPath.row]
        navigationController?.pushViewController(classDetailController, animated: true)
    }

}
