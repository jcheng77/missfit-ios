//
//  TeacherDetailViewController.swift
//  missfit
//
//  Created by Hank Liang on 4/20/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class TeacherDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CommentComposeViewControllerDelegate {
    var teacherInfo: MissFitTeacher?
    var kTeacherImageCellIndex = 0
    var kTeacherInfoCellIndex = 1
    var kTeacherManifestoCellIndex = 2
    var kTeacherCertificationsCellIndex = 3
    var kTeacherCommentSectionCellIndex = 4
    @IBOutlet weak var tableView: UITableView!
    var scene: WXScene = WXSceneSession
    @IBOutlet weak var likes: UILabel!
    var comments = [MissFitComment]()
    var likesNumber: Int = 0
    var commentsLoadedSucceeded: Bool?
    
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
        UmengHelper.event(AnalyticsClickShareTeacher)
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
        UmengHelper.event(AnalyticsClickTeacherClasses, label: self.teacherInfo!.name)
        let teacherClassesController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TeacherClassesViewController") as! TeacherClassesViewController
        teacherClassesController.teacherInfo = self.teacherInfo
        navigationController?.pushViewController(teacherClassesController, animated: true)
    }
    
    @IBAction func thumbupButtonClicked(sender: AnyObject) {
        if MissFitUser.user.isLogin {
            var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
            var endpoint: String = MissFitBaseURL + MissFitTeachersURI + "/" + teacherInfo!.teacherId + "/" + MissFitLikesURI
            
            KVNProgress.show()
            manager.requestSerializer.setValue(MissFitUser.user.userId, forHTTPHeaderField: "X-User-Id")
            manager.requestSerializer.setValue(MissFitUser.user.token, forHTTPHeaderField: "X-Auth-Token")
            manager.POST(endpoint, parameters: nil, success: { (operation, responseObject) -> Void in
                self.likesNumber += 1
                self.updateLikes()
                KVNProgress.dismiss()
                }) { (operation, error) -> Void in
                    if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                        // Need to get the status and message
                        let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData)
                        let message: String? = json["message"].string
                        KVNProgress.showErrorWithStatus(message)
                    } else {
                        KVNProgress.showErrorWithStatus("点赞失败")
                    }
            }
        } else {
            let alert: UIAlertController = UIAlertController(title: "温馨提示", message: "请先登录再点赞", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "确定", style: .Cancel) { (action: UIAlertAction!) -> Void in
                // Do nothing
                let loginController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
                self.presentViewController(UINavigationController(rootViewController: loginController), animated: true, completion: nil)
            }
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func composeButtonClicked(sender: AnyObject) {
        if MissFitUser.user.isLogin {
            let composeController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CommentComposeViewController") as! CommentComposeViewController
            composeController.teacher = teacherInfo
            composeController.delegate = self
            self.presentViewController(UINavigationController(rootViewController: composeController), animated: true, completion: nil)
        } else {
            let alert: UIAlertController = UIAlertController(title: "温馨提示", message: "请先登录再点评论", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "确定", style: .Cancel) { (action: UIAlertAction!) -> Void in
                // Do nothing
                let loginController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
                self.presentViewController(UINavigationController(rootViewController: loginController), animated: true, completion: nil)
            }
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func updateLikes() {
        likes.text = String(likesNumber)
    }
    
    func parseCommentsResponseObject(responseObject: NSDictionary) {
        let json = JSON(responseObject)
        for (key: String, subJson: JSON) in json {
            if key == "data" {
                for (index: String, thirdJson: JSON) in subJson {
                    let comment: MissFitComment = MissFitComment(json: thirdJson)
                    self.comments.append(comment)
                }
            }
        }
    }
    
    func parsePraisesResponseObject(responseObject: NSDictionary) {
        let json = JSON(responseObject)
        for (key: String, subJson: JSON) in json {
            if key == "data" {
                if let number = subJson["count"].number {
                    self.likesNumber = number.integerValue
                    self.updateLikes()
                    break
                }
            }
        }
    }
    
    func fetchComments() {
        comments = []
        var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        var endpoint: String = MissFitBaseURL + MissFitTeachersURI + "/" + teacherInfo!.teacherId + "/" + MissFitCommentsURI
        
        manager.GET(endpoint, parameters: nil, success: { (operation, responseObject) -> Void in
            // Parse data
            self.commentsLoadedSucceeded = true
            self.parseCommentsResponseObject(responseObject as! NSDictionary)
            self.tableView.reloadData()
            }) { (operation, error) -> Void in
                if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                    // Need to get the status and message
                    let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData)
                    let message: String? = json["message"].string
                    KVNProgress.showErrorWithStatus(message)
                } else {
                    KVNProgress.showErrorWithStatus("获取评论失败")
                }
                self.commentsLoadedSucceeded = false
                self.tableView.reloadData()
        }
    }
    
    func fetchLikes() {
        var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        var endpoint: String = MissFitBaseURL + MissFitTeachersURI + "/" + teacherInfo!.teacherId + "/" + MissFitLikesURI
        
        manager.GET(endpoint, parameters: nil, success: { (operation, responseObject) -> Void in
            // Parse data
            self.parsePraisesResponseObject(responseObject as! NSDictionary)
            }) { (operation, error) -> Void in
                if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                    // Need to get the status and message
                    let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData)
                    let message: String? = json["message"].string
                    println("error:\(message)")
                } else {
                    println("error:获取赞数失败")
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.comments.append(MissFitComment())
        if WXApi.isWXAppInstalled() && WXApi.isWXAppSupportApi() {
            // do nothing
        } else {
            navigationItem.rightBarButtonItem = nil
        }
        updateLikes()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        if !teacherInfo!.teacherCertification!.isCertified {
            kTeacherCertificationsCellIndex = -1
            kTeacherCommentSectionCellIndex = 3
        }
        
        fetchLikes()
        fetchComments()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.teacherInfo!.teacherCertification!.isCertified ? 5 : 4) + self.comments.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == kTeacherImageCellIndex {
            let cell = tableView.dequeueReusableCellWithIdentifier("TeacherImageTableViewCell", forIndexPath: indexPath) as! TeacherImageTableViewCell
            if let picUrls = self.teacherInfo?.pics {
                cell.setData(picUrls)
            }
            return cell
        } else if indexPath.row == kTeacherInfoCellIndex {
            let cell = tableView.dequeueReusableCellWithIdentifier("TeacherInfoTableViewCell", forIndexPath: indexPath) as! TeacherInfoTableViewCell
            cell.name.text = self.teacherInfo?.name
            cell.verifiedIcon.hidden = !self.teacherInfo!.idVerified
            cell.teachScopes.text = self.teacherInfo?.classScopesString()
            if let areas = self.teacherInfo?.teachAreas {
                cell.district.text = areas
            }
            cell.teachModes.text = self.teacherInfo?.teachModesString()
            cell.price.text = self.teacherInfo?.price
            return cell
        } else if indexPath.row == kTeacherManifestoCellIndex {
            let cell = tableView.dequeueReusableCellWithIdentifier("TeacherManifestoTableViewCell", forIndexPath: indexPath) as! TeacherManifestoTableViewCell
            cell.manifesto.text = self.teacherInfo?.manifesto
            return cell
        } else if indexPath.row == kTeacherCertificationsCellIndex {
            let cell = tableView.dequeueReusableCellWithIdentifier("TeacherCertificationsTableViewCell", forIndexPath: indexPath) as! TeacherCertificationsTableViewCell
            if self.teacherInfo!.teacherCertification!.isIdCertified {
                cell.certifiedType1.text = "身份验证"
                cell.certifiedTypeIcon1.image = UIImage(named: "credit-card-certified")
                if self.teacherInfo!.teacherCertification!.isPhoneCertified {
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
        } else if indexPath.row == kTeacherCommentSectionCellIndex {
            let cell = tableView.dequeueReusableCellWithIdentifier("CommentSectionTableViewCell", forIndexPath: indexPath) as! CommentSectionTableViewCell
            if self.commentsLoadedSucceeded == nil {
                cell.activityView.startAnimating()
                cell.errorMessage.hidden = true
                cell.noComments.hidden = true
            } else {
                if self.commentsLoadedSucceeded! {
                    cell.activityView.stopAnimating()
                    cell.errorMessage.hidden = true
                    if self.comments.count > 0 {
                        cell.noComments.hidden = true
                    } else {
                        cell.noComments.hidden = false
                    }
                } else {
                    cell.activityView.stopAnimating()
                    cell.errorMessage.hidden = false
                    cell.noComments.hidden = true
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("CommentTableViewCell", forIndexPath: indexPath) as! CommentTableViewCell
            cell.setData(self.comments[indexPath.row - kTeacherCommentSectionCellIndex - 1])
            return cell
        }
    }
    
    // MARK: - CommentComposeViewControllerDelegate
    func commentPostSucceeded() {
        self.commentsLoadedSucceeded = nil
        self.fetchComments()
        self.tableView.reloadData()
    }
}
