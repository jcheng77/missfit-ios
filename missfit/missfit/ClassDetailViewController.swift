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
    
    @IBAction func bookButtonClicked(sender: AnyObject) {
        let alert: UIAlertController = UIAlertController(title: "提示", message: "你确定要预约本次课程吗？", preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "确定", style: .Default) { (action: UIAlertAction!) -> Void in
            if MissFitUser.user.isLogin {
                var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
                var endpoint: String = MissFitBaseURL + MissFitClassesURI + "/" + self.missfitClass!.classId + MissFitClassesBookingURI
                
                KVNProgress.show()
                manager.requestSerializer = AFHTTPRequestSerializer()
                manager.requestSerializer.setValue(MissFitUser.user.userId, forHTTPHeaderField: "X-User-Id")
                manager.requestSerializer.setValue(MissFitUser.user.token, forHTTPHeaderField: "X-Auth-Token")
                manager.POST(endpoint, parameters: nil, success: { (operation, responseObject) -> Void in
                    KVNProgress.showSuccessWithStatus("预约成功")
                    self.dismissViewControllerAnimated(true, completion: nil)
                    }) { (operation, error) -> Void in
                        if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                            // Need to get the status and message
                            let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as NSData)
                            let message: String? = json["message"].string
                            KVNProgress.showErrorWithStatus(message?)
                        } else {
                            KVNProgress.showErrorWithStatus("预约失败")
                        }
                }

            } else {
                let loginController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as UIViewController
                self.presentViewController(UINavigationController(rootViewController: loginController), animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel) { (action: UIAlertAction!) -> Void in
            // Do nothing
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
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
        return UITableViewAutomaticDimension
    }

}
