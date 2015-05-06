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
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func classesButtonClicked(sender: AnyObject) {
    }
    
    @IBAction func orderButtonClicked(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            let cell = tableView.dequeueReusableCellWithIdentifier("TeacherImageTableViewCell", forIndexPath: indexPath) as TeacherImageTableViewCell
            if let picUrl = teacherInfo?.coverPicUrl {
                cell.teacherImage?.setImageWithURL(NSURL(string: picUrl))
            }
            return cell
        } else if indexPath.row == kTeacherInfoCellIndex {
            let cell = tableView.dequeueReusableCellWithIdentifier("TeacherInfoTableViewCell", forIndexPath: indexPath) as TeacherInfoTableViewCell
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
            let cell = tableView.dequeueReusableCellWithIdentifier("TeacherManifestoTableViewCell", forIndexPath: indexPath) as TeacherManifestoTableViewCell
            cell.manifesto.text = teacherInfo?.manifesto
            return cell
        } else if indexPath.row == kTeacherCertificationsCellIndex {
            let cell = tableView.dequeueReusableCellWithIdentifier("TeacherCertificationsTableViewCell", forIndexPath: indexPath) as TeacherCertificationsTableViewCell
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
            let cell = tableView.dequeueReusableCellWithIdentifier("TeacherActionsTableViewCell", forIndexPath: indexPath) as TeacherActionsTableViewCell
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
