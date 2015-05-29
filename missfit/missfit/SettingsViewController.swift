//
//  SettingsViewController.swift
//  missfit
//
//  Created by Hank Liang on 4/26/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var memberFee: Float = 0.0
    var isMembershipLoaded = false
    let sectionsInfo = [["key": "个人信息", "value": ["姓名", "电话"]], ["key": "会员卡", "value": ["月卡", "月卡使用规则"]], ["key": "关于我们", "value": ["服务条款"]], ]

    @IBAction func backButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func dialButtonClicked(sender: AnyObject) {
        let servicePhoneNumber = (sender as! UIButton).titleForState(.Normal)
        UIApplication.sharedApplication().openURL(NSURL(string: "telprompt://" + servicePhoneNumber!.stringByReplacingOccurrencesOfString("-", withString: "", options: nil, range: nil))!)
    }
    
    @IBAction func logoutButtonClicked(sender: AnyObject) {
        var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        var endpoint: String = MissFitBaseURL + MissFitLogoutURI
        
        KVNProgress.show()
        manager.requestSerializer.setValue(MissFitUser.user.userId, forHTTPHeaderField: "X-User-Id")
        manager.requestSerializer.setValue(MissFitUser.user.token, forHTTPHeaderField: "X-Auth-Token")
        manager.GET(endpoint, parameters: nil, success: { (operation, responseObject) -> Void in
            KVNProgress.showSuccessWithStatus("退出登录成功")
            // Parse data
            MissFitUser.user.logout()
            self.dismissViewControllerAnimated(true, completion: nil)
            }) { (operation, error) -> Void in
                if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                    // Need to get the status and message
                    let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData)
                    let message: String? = json["message"].string
                    KVNProgress.showErrorWithStatus(message)
                } else {
                    KVNProgress.showErrorWithStatus("退出登录失败")
                }
        }
    }
    
    func loadMembership() {
        self.tableView.reloadData()
        MissFitUser.user.loadMembershipInfo()
    }
    
    func loadMembershipSucceeded() {
        isMembershipLoaded = true
        self.tableView.reloadData()
        self.tableView.stopPullToRefresh()
    }
    
    func loadMembershipFailed() {
        isMembershipLoaded = false
        self.tableView.reloadData()
        self.tableView.stopPullToRefresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("loadMembershipSucceeded"), name: MissFitLoadMembershipSucceededCallback, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("loadMembershipFailed"), name: MissFitLoadMembershipFailureCallback, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        isMembershipLoaded = false
        self.loadSettings()

        
        if tableView.pullToRefreshView == nil {
            tableView.addPullToRefreshWithAction({ () -> () in
                self.loadSettings()
                }, withAnimator: BeatAnimator())
        }
    }
    
    func parseResponseObject(responseObject: NSDictionary) {
        let json = JSON(responseObject)
        for (key: String, subJson: JSON) in json {
            if key == "data" {
                self.memberFee = subJson["member_fee"].floatValue
            }
        }
    }
    
    func loadSettings() {
        var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        var endpoint: String = MissFitBaseURL + MissFitSettings
        manager.requestSerializer.setValue(MissFitUser.user.userId, forHTTPHeaderField: "X-User-Id")
        manager.requestSerializer.setValue(MissFitUser.user.token, forHTTPHeaderField: "X-Auth-Token")
        KVNProgress.show()
        manager.GET(endpoint, parameters: nil, success: { (operation, responseObject) -> Void in
            MissFitUser.user.loadMembershipInfo()
            self.parseResponseObject(responseObject as! NSDictionary)
            }) { (operation, error) -> Void in
                if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                    // Need to get the status and message
                    let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData)
                    let message: String? = json["message"].string
                    KVNProgress.showErrorWithStatus(message)
                } else {
                    KVNProgress.showErrorWithStatus("获取设置信息失败")
                }
                self.tableView.stopPullToRefresh()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if isMembershipLoaded {
            return sectionsInfo.count

        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsInfo[section]["key"] as? String
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isMembershipLoaded {
            if sectionsInfo[section]["key"] as! String == "关于我们" {
                return (sectionsInfo[section]["value"] as! [String]).count + 1
            } else {
                return (sectionsInfo[section]["value"] as! [String]).count
            }
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if sectionsInfo[indexPath.section]["key"] as! String == "个人信息" {
            if (sectionsInfo[indexPath.section]["value"] as! [String])[indexPath.row] == "姓名" {
                let cell = tableView.dequeueReusableCellWithIdentifier("SettingsNormalTableViewCell", forIndexPath: indexPath) as! SettingsNormalTableViewCell
                cell.key.text = (sectionsInfo[indexPath.section]["value"] as! [String])[indexPath.row]
                // TODO: need to set different value for different cell
                cell.value.text = MissFitUser.user.nickName
                if indexPath.row == (sectionsInfo[indexPath.section]["value"] as! [String]).count - 1 {
                    cell.seperator.hidden = true
                } else {
                    cell.seperator.hidden = false
                }
                return cell
            } else if (sectionsInfo[indexPath.section]["value"] as! [String])[indexPath.row] == "电话" {
                let cell = tableView.dequeueReusableCellWithIdentifier("SettingsNormalTableViewCell", forIndexPath: indexPath) as! SettingsNormalTableViewCell
                cell.key.text = (sectionsInfo[indexPath.section]["value"] as! [String])[indexPath.row]
                // TODO: need to set different value for different cell
                cell.value.text = MissFitUser.user.phoneNumber
                if indexPath.row == (sectionsInfo[indexPath.section]["value"] as! [String]).count - 1 {
                    cell.seperator.hidden = true
                } else {
                    cell.seperator.hidden = false
                }
                return cell
            } else {
                return UITableViewCell()
            }
        } else if sectionsInfo[indexPath.section]["key"] as! String == "会员卡" {
            // According to the info loaded from server
            if (sectionsInfo[indexPath.section]["value"] as! [String])[indexPath.row] == "月卡" {
                let cell = tableView.dequeueReusableCellWithIdentifier("SettingsDetailTableViewCell", forIndexPath: indexPath) as! SettingsDetailTableViewCell
                cell.content.text = (sectionsInfo[indexPath.section]["value"] as! [String])[indexPath.row]
                if MissFitUser.user.hasMonthlyCard {
                    cell.status.text = "有效期至"
                    cell.detail.text = MissFitUser.user.monthlyCardValidThrough
                } else {
                    cell.status.text = "未购买"
                    cell.detail.text = "¥" + NSNumber(float: memberFee).stringValue
                }
                cell.detail.hidden = false
                cell.status.hidden = false
                cell.line.hidden = false
                return cell
            } else if (sectionsInfo[indexPath.section]["value"] as! [String])[indexPath.row] == "月卡使用规则" {
                // member card rules
                let cell = tableView.dequeueReusableCellWithIdentifier("SettingsDetailTableViewCell", forIndexPath: indexPath) as! SettingsDetailTableViewCell
                cell.content.text = (sectionsInfo[indexPath.section]["value"] as! [String])[indexPath.row]
                cell.detail.hidden = true
                cell.status.hidden = true
                cell.line.hidden = true
                return cell
            } else {
                return UITableViewCell()
            }
        } else if sectionsInfo[indexPath.section]["key"] as! String == "关于我们" {
            if indexPath.row < (sectionsInfo[indexPath.section]["value"] as! [String]).count {
                let cell = tableView.dequeueReusableCellWithIdentifier("SettingsDetailTableViewCell", forIndexPath: indexPath) as! SettingsDetailTableViewCell
                cell.content.text = (sectionsInfo[indexPath.section]["value"] as! [String])[indexPath.row]
                cell.detail.hidden = true
                cell.status.hidden = true
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("SettingsActionTableViewCell", forIndexPath: indexPath) as! SettingsActionTableViewCell
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = MissFitTheme.theme.colorHeaderBackground
        header.textLabel.textColor = MissFitTheme.theme.colorDarkText
        header.textLabel.font = UIFont.systemFontOfSize(14)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if sectionsInfo[indexPath.section]["key"] as! String == "关于我们" {
            let stringArray = sectionsInfo[indexPath.section]["value"] as! [String]
            if indexPath.row < stringArray.count && stringArray[indexPath.row] == "服务条款" {
                let touController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TermsOfUseViewController") as! TermsOfUseViewController
                navigationController?.pushViewController(touController, animated: true)
            }
        } else if sectionsInfo[indexPath.section]["key"] as! String == "会员卡" {
            let stringArray = sectionsInfo[indexPath.section]["value"] as! [String]
            if indexPath.row < stringArray.count {
                if stringArray[indexPath.row] == "月卡" {
                    // navigate to payment view controller
                    let paymentController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PaymentViewController") as! PaymentViewController
                    paymentController.settingsController = self
                    
                    let oneMonthTimeInterval: Double = 3600 * 24 * 30
                    if MissFitUser.user.hasMonthlyCard {
                        paymentController.validThrough = MissFitUtils.formatDate(NSDate(timeInterval: oneMonthTimeInterval, sinceDate: MissFitUtils.dateFromString(MissFitUser.user.monthlyCardValidThrough!)))
                    } else {
                        // 30 days
                        paymentController.validThrough = MissFitUtils.formatDate( NSDate(timeInterval: oneMonthTimeInterval, sinceDate: NSDate()))
                    }
                    paymentController.memberFee = NSNumber(float: memberFee).stringValue
                    navigationController?.pushViewController(paymentController, animated: true)
                } else if stringArray[indexPath.row] == "月卡使用规则" {
                    let memberCardInfoController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MemberCardInfoViewController") as! MemberCardInfoViewController
                    navigationController?.pushViewController(memberCardInfoController, animated: true)
                }
            }
        }
    }

}
