//
//  ClassDetailViewController.swift
//  missfit
//
//  Created by Hank Liang on 4/20/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

enum ClassDetailCellIndex: Int {
    case ClassDetailImageCell = 0, ClassDetailBookCell, ClassDetailInfoCell, ClassDetailLocationCell
}

class ClassDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let kRowNumber = 4
    let classCoverImageAspectRatio: CGFloat = 488.0 / 640.0
    var missfitClass: MissFitClass?
    var scene: WXScene = WXSceneSession
    weak var myClassesController: MyClassesViewController?
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if WXApi.isWXAppInstalled() && WXApi.isWXAppSupportApi() {
            // do nothing
        } else {
            navigationItem.rightBarButtonItem = nil
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("loadMembershipSucceededCallback"), name: MissFitLoadMembershipSucceededCallback, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func loadMembershipSucceededCallback() {
        if MissFitUser.user.hasMonthlyCard  && !MissFitUser.user.isMonthlyCardExpired() {
            tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func locationInfoButtonClicked(sender: AnyObject) {
        UmengHelper.event(AnalyticsClickLocationDetail)
        let locationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LocationDetailViewController") as! LocationDetailViewController
        locationController.missfitLocation = self.missfitClass?.location
        navigationController?.pushViewController(locationController, animated: true)
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        if myClassesController != nil {
        }
        myClassesController?.fetchData(MyClassCategory.Class)
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func actionButtonClicked(sender: AnyObject) {
        let sheet = UIAlertController(title: "推荐好友", message: nil, preferredStyle: .ActionSheet)
        let wxFriendAction = UIAlertAction(title: "微信好友", style: .Default) { (action: UIAlertAction!) -> Void in
            self.scene = WXSceneSession
            self.sendClassInfo()
        }
        
        let wxTimelineAction = UIAlertAction(title: "微信朋友圈", style: .Default) { (action: UIAlertAction!) -> Void in
            self.scene = WXSceneTimeline
            self.sendClassInfo()
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel) { (action: UIAlertAction!) -> Void in
            // Do nothing
        }
        
        sheet.addAction(wxFriendAction)
        sheet.addAction(wxTimelineAction)
        sheet.addAction(cancelAction)
        
        presentViewController(sheet, animated: true, completion: nil)

    }
    
    func sendClassInfo() {
        UmengHelper.event(AnalyticsClickShareClass)
        let message = WXMediaMessage()
        message.title = "美人瑜 - " + self.missfitClass!.name
        message.description = "你身边的瑜伽健身教练"
        message.setThumbImage(UIImage(named: "logo"))

        let ext = WXWebpageObject()
        ext.webpageUrl = MissFitSharingClassURI + self.missfitClass!.classId
        
        message.mediaObject = ext;
        message.mediaTagName = "WECHAT_TAG_JUMP_SHOWRANK"
        
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(self.scene.value)
        WXApi.sendReq(req)
    }
    
    @IBAction func bookButtonClicked(sender: AnyObject) {
        if missfitClass!.isBooked {
            UmengHelper.event(AnalyticsClickCancelClass)
            let alert: UIAlertController = UIAlertController(title: "提示", message: "你确定要取消本次课程的预约吗？", preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: "确定", style: .Default) { (action: UIAlertAction!) -> Void in
                UmengHelper.event(AnalyticsConfirmCancelBookingClass)
                var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
                var endpoint: String = MissFitBaseURL + MissFitClassesBookingURI + "/" + self.missfitClass!.bookingId!
                
                KVNProgress.show()
                manager.requestSerializer.setValue(MissFitUser.user.userId, forHTTPHeaderField: "X-User-Id")
                manager.requestSerializer.setValue(MissFitUser.user.token, forHTTPHeaderField: "X-Auth-Token")
                manager.DELETE(endpoint, parameters: nil, success: { (operation, responseObject) -> Void in
                    KVNProgress.showSuccessWithStatus("取消预约成功")
                    UmengHelper.event(AnalyticsCancelBookingClassSucceed)
                    self.missfitClass!.isBooked = false
                    self.tableView.reloadData()
                    }) { (operation, error) -> Void in
                        if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                            // Need to get the status and message
                            let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData)
                            let message: String? = json["message"].string
                            KVNProgress.showErrorWithStatus(message)
                        } else {
                            KVNProgress.showErrorWithStatus("取消预约失败")
                        }
                }
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel) { (action: UIAlertAction!) -> Void in
                // Do nothing
            }
            
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            presentViewController(alert, animated: true, completion: nil)
        } else {
            UmengHelper.event(AnalyticsClickBookingClass)
            let alert: UIAlertController = UIAlertController(title: "提示", message: "你确定要预约本次课程吗？", preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: "确定", style: .Default) { (action: UIAlertAction!) -> Void in
                UmengHelper.event(AnalyticsConfirmBookingClass)
                if MissFitUser.user.isLogin {
                    var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
                    var endpoint: String = MissFitBaseURL + MissFitClassesURI + "/" + self.missfitClass!.classId + "/" + MissFitClassesBookingURI
                    
                    KVNProgress.show()
                    manager.requestSerializer.setValue(MissFitUser.user.userId, forHTTPHeaderField: "X-User-Id")
                    manager.requestSerializer.setValue(MissFitUser.user.token, forHTTPHeaderField: "X-Auth-Token")
                    manager.POST(endpoint, parameters: nil, success: { (operation, responseObject) -> Void in
                        self.missfitClass!.bookingId = (responseObject as! NSDictionary)["data"] as? String
                        self.missfitClass!.isBooked = true
                        self.tableView.reloadData()
                        KVNProgress.showSuccessWithStatus("预约成功")
                        UmengHelper.event(AnalyticsBookClassSucceed)
                        }) { (operation, error) -> Void in
                            let statusCode = operation.response.statusCode
                            if statusCode == 403 {
                                // Need to pay
                                KVNProgress.dismiss()
                                UmengHelper.event(AnalyticsBookClassButNotPay)
                                let paymentController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PaymentViewController") as! PaymentViewController
                                paymentController.missfitClass = self.missfitClass
                                self.navigationController?.pushViewController(paymentController, animated: true)

                            } else {
                                if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                                    // Need to get the status and message
                                    let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData)
                                    let message: String? = json["message"].string
                                    KVNProgress.showErrorWithStatus(message)
                                } else {
                                    KVNProgress.showErrorWithStatus("预约失败")
                                }
                            }

                    }
                } else {
                    UmengHelper.event(AnalyticsBookClassButNotLogin)
                    let alert: UIAlertController = UIAlertController(title: "温馨提示", message: "请先登录再约课", preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "确定", style: .Cancel) { (action: UIAlertAction!) -> Void in
                        // Do nothing
                        let loginController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
                        self.presentViewController(UINavigationController(rootViewController: loginController), animated: true, completion: nil)
                    }
                    
                    alert.addAction(cancelAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel) { (action: UIAlertAction!) -> Void in
                // Do nothing
            }
            
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            presentViewController(alert, animated: true, completion: nil)
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kRowNumber
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case ClassDetailCellIndex.ClassDetailImageCell.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("ClassDetailImageTableViewCell", forIndexPath: indexPath) as! ClassDetailImageTableViewCell
            cell.setData(missfitClass!)
            return cell
        case ClassDetailCellIndex.ClassDetailBookCell.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("ClassDetailBookTableViewCell", forIndexPath: indexPath) as! ClassDetailBookTableViewCell
            if missfitClass!.isBooked {
                cell.bookButton.setTitle("取消预约", forState: .Normal)
            } else {
                cell.bookButton.setTitle("我要预约", forState: .Normal)
            }
            return cell
        case ClassDetailCellIndex.ClassDetailInfoCell.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("ClassDetailInfoTableViewCell", forIndexPath: indexPath) as! ClassDetailInfoTableViewCell
            cell.setData(missfitClass!)
            return cell
        case ClassDetailCellIndex.ClassDetailLocationCell.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("ClassDetailLocationTableViewCell", forIndexPath: indexPath) as! ClassDetailLocationTableViewCell
            cell.setData(missfitClass!.location)
            return cell
        default:
            return UITableViewCell()
        }
    }

}
