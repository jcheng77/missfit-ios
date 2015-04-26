//
//  SettingsViewController.swift
//  missfit
//
//  Created by Hank Liang on 4/26/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let sectionsInfo = [["key": "个人信息", "value": ["电话"]], /*"所在城市", "账户信息", */["key": "关于我们", "value": ["服务条款"]]]

    @IBAction func backButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func dialButtonClicked(sender: AnyObject) {
        let servicePhoneNumber = (sender as UIButton).titleForState(.Normal)
        UIApplication.sharedApplication().openURL(NSURL(string: "telprompt://" + servicePhoneNumber!.stringByReplacingOccurrencesOfString("-", withString: "", options: nil, range: nil))!)
    }
    
    @IBAction func logoutButtonClicked(sender: AnyObject) {
        var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        var endpoint: String = MissFitBaseURL + MissFitLogoutURI
        
        KVNProgress.show()
        manager.requestSerializer = AFHTTPRequestSerializer()
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
                    let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as NSData)
                    let message: String? = json["message"].string
                    KVNProgress.showErrorWithStatus(message?)
                } else {
                    KVNProgress.showErrorWithStatus("退出登录失败")
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionsInfo.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsInfo[section]["key"] as? String
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionsInfo[section]["key"] as String == "关于我们" {
            return (sectionsInfo[section]["value"]! as [String]).count + 1
        } else {
            return (sectionsInfo[section]["value"]! as [String]).count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if sectionsInfo[indexPath.section]["key"] as String == "个人信息" {
            let cell = tableView.dequeueReusableCellWithIdentifier("SettingsNormalTableViewCell", forIndexPath: indexPath) as SettingsNormalTableViewCell
            cell.key.text = (sectionsInfo[indexPath.section]["value"]! as [String])[indexPath.row]
            // TODO: need to set different value for different cell
            cell.value.text = MissFitUser.user.phoneNumber
            if indexPath.row == (sectionsInfo[indexPath.section]["value"] as [String]).count - 1 {
                cell.seperator.hidden = true
            } else {
                cell.seperator.hidden = false
            }
            return cell
        } else if sectionsInfo[indexPath.section]["key"] as String == "关于我们" {
            if indexPath.row < (sectionsInfo[indexPath.section]["value"]! as [String]).count {
                let cell = tableView.dequeueReusableCellWithIdentifier("SettingsDetailTableViewCell", forIndexPath: indexPath) as SettingsDetailTableViewCell
                cell.content.text = (sectionsInfo[indexPath.section]["value"]! as [String])[indexPath.row]
                cell.detail.hidden = true
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("SettingsActionTableViewCell", forIndexPath: indexPath) as SettingsActionTableViewCell
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as UITableViewHeaderFooterView
        header.contentView.backgroundColor = MissFitTheme.theme.colorHeaderBackground
        header.textLabel.textColor = MissFitTheme.theme.colorDarkText
        header.textLabel.font = UIFont.systemFontOfSize(14)
    }

}
