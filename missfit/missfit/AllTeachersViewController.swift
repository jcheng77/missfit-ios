//
//  AllTeachersViewController.swift
//  missfit
//
//  Created by Hank Liang on 4/18/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit
import CoreLocation

class AllTeachersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    let teacherCoverImageAspectRatio: CGFloat = 426.0 / 640.0
    let locationManager = CLLocationManager()
    var allowUseLocation = false
    var currentLocation: CLLocation?
    
    @IBOutlet weak var tableView: UITableView!
    var teachers = [MissFitTeacher]()
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func refreshData() {
        teachers = []
        var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        var endpoint: String = MissFitBaseURL + MissFitTeachersURI
        
        if allowUseLocation {
            endpoint = endpoint + MissFitTeachersLocationURI + "\(currentLocation!.coordinate.longitude),\(currentLocation!.coordinate.latitude)"
            println("endpoint:\(endpoint)")
        }
        
        KVNProgress.show()
        manager.GET(endpoint, parameters: nil, success: { (operation, responseObject) -> Void in
//            KVNProgress.showSuccessWithStatus("获取老师列表成功！")
            KVNProgress.dismiss()
            println("responseObject:\(responseObject)")
            // Parse data
            self.parseResponseObject(responseObject as NSDictionary)
            self.tableView.reloadData()
        }) { (operation, error) -> Void in
            if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                // Need to get the status and message
                let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as NSData)
                let message: String? = json["message"].string
                KVNProgress.showErrorWithStatus(message?)
            } else {
                KVNProgress.showErrorWithStatus("获取老师列表失败")
            }
        }
    }
    
    func loadMoreData(page: Int) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TeacherTableViewCell", forIndexPath: indexPath) as TeacherTableViewCell
        
        cell.setData(teachers[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0 + MissFitUtils.shortestScreenWidth() * teacherCoverImageAspectRatio
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let teacherInfo = teachers[indexPath.row]
        let teacherDetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TeacherDetailViewController") as TeacherDetailViewController
        teacherDetailController.teacherInfo = teacherInfo
        navigationController?.pushViewController(teacherDetailController, animated: true)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
//            allowUseLocation = true
        } else {
            // TODO: ask the user to allow the permission
            println("Open the location permission in the settings.")
            refreshData()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("didFailWithError:\(error)")
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if currentLocation == nil {
            currentLocation = locations.last as? CLLocation
            println("didUpdateToLocation:\(currentLocation)")
            locationManager.stopUpdatingLocation()
            allowUseLocation = true
            refreshData()
        }
    }

}
