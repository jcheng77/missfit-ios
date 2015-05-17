//
//  TeacherDetailViewController.swift
//  missfit
//
//  Created by Hank Liang on 4/20/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class TeacherDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var teacherInfo: MissFitTeacher?
    var kTeacherImageCellIndex = 0
    var kTeacherInfoCellIndex = 1
    var kTeacherManifestoCellIndex = 2
    var kTeacherCertificationsCellIndex = 3
    var kTeacherActionsCellIndex = 4
    @IBOutlet weak var tableView: UITableView!
    var scene: WXScene = WXSceneSession
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func actionButtonClicked(sender: AnyObject) {
        let sheet = UIAlertController(title: "推荐好友", message: nil, preferredStyle: .ActionSheet)
        let wxFriendAction = UIAlertAction(title: "微信好友", style: .Default) { (action: UIAlertAction!) -> Void in
            self.scene = WXSceneSession
            self.sendTeacherInfo()
        }
        
        let wxTimelineAction = UIAlertAction(title: "微信朋友圈", style: .Default) { (action: UIAlertAction!) -> Void in
            self.scene = WXSceneTimeline
            self.sendTeacherInfo()
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel) { (action: UIAlertAction!) -> Void in
            // Do nothing
        }
        
        sheet.addAction(wxFriendAction)
        sheet.addAction(wxTimelineAction)
        sheet.addAction(cancelAction)
        
        presentViewController(sheet, animated: true, completion: nil)
    }
    
    func sendTeacherInfo() {
        let message = WXMediaMessage()
        message.title = "美人瑜 - " + self.teacherInfo!.name
        message.description = "你身边的瑜伽健身教练"
        message.setThumbImage(UIImage(named: "logo"))
        
        let ext = WXWebpageObject()
        ext.webpageUrl = MissFitSharingTeacherURI + self.teacherInfo!.teacherId
        
        message.mediaObject = ext;
        message.mediaTagName = "WECHAT_TAG_JUMP_SHOWRANK"
        
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(self.scene.value)
        WXApi.sendReq(req)
    }
    
    @IBAction func classesButtonClicked(sender: AnyObject) {
    }
    
    @IBAction func orderButtonClicked(sender: AnyObject) {
        if MissFitUser.user.isLogin {
            let teacherBookingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TeacherBookingViewController") as! TeacherBookingViewController
            teacherBookingController.teacherInfo = teacherInfo
            navigationController?.pushViewController(teacherBookingController, animated: true)
        } else {
            let loginController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
            self.presentViewController(UINavigationController(rootViewController: loginController), animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if WXApi.isWXAppInstalled() && WXApi.isWXAppSupportApi() {
            // do nothing
        } else {
            navigationItem.rightBarButtonItem = nil
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        if !teacherInfo!.teacherCertification!.isCertified {
            kTeacherCertificationsCellIndex = -1
            kTeacherActionsCellIndex = 3
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teacherInfo!.teacherCertification!.isCertified ? 5 : 4
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == kTeacherImageCellIndex {
            let cell = tableView.dequeueReusableCellWithIdentifier("TeacherImageTableViewCell", forIndexPath: indexPath) as! TeacherImageTableViewCell
            if let picUrls = teacherInfo?.pics {
                cell.setData(picUrls)
            }
            return cell
        } else if indexPath.row == kTeacherInfoCellIndex {
            let cell = tableView.dequeueReusableCellWithIdentifier("TeacherInfoTableViewCell", forIndexPath: indexPath) as! TeacherInfoTableViewCell
            cell.name.text = teacherInfo?.name
            cell.verifiedIcon.hidden = !teacherInfo!.idVerified
            cell.teachScopes.text = teacherInfo?.classScopesString()
            if let districtString = teacherInfo?.district {
                cell.district.text = "【" + districtString + "】"
            }
            cell.area.text = teacherInfo?.area
            cell.teachModes.text = teacherInfo?.teachModesString()
            if let priceString = teacherInfo?.price {
                cell.price.text = priceString + "元/小时"
            }
            return cell
        } else if indexPath.row == kTeacherManifestoCellIndex {
            let cell = tableView.dequeueReusableCellWithIdentifier("TeacherManifestoTableViewCell", forIndexPath: indexPath) as! TeacherManifestoTableViewCell
            cell.manifesto.text = teacherInfo?.manifesto
            return cell
        } else if indexPath.row == kTeacherCertificationsCellIndex {
            let cell = tableView.dequeueReusableCellWithIdentifier("TeacherCertificationsTableViewCell", forIndexPath: indexPath) as! TeacherCertificationsTableViewCell
            if teacherInfo!.teacherCertification!.isIdCertified {
                cell.certifiedType1.text = "身份验证"
                cell.certifiedTypeIcon1.image = UIImage(named: "credit-card-certified")
                if teacherInfo!.teacherCertification!.isPhoneCertified {
                    cell.certifiedType2.text = "手机验证"
                    cell.certifiedTypeIcon2.image = UIImage(named: "phone-certified")
                } else {
                    cell.certifiedType2.hidden = true
                    cell.certifiedTypeIcon2.hidden = true
                }
            } else {
                cell.certifiedType1.text = "手机验证"
                cell.certifiedTypeIcon1.image = UIImage(named: "phone-certified")
                cell.certifiedType2.hidden = true
                cell.certifiedTypeIcon2.hidden = true
            }
            return cell
        } else if indexPath.row == kTeacherActionsCellIndex {
            let cell = tableView.dequeueReusableCellWithIdentifier("TeacherActionsTableViewCell", forIndexPath: indexPath) as! TeacherActionsTableViewCell
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
