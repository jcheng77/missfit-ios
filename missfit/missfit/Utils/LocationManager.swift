//
//  LocationManager.swift
//  missfit
//
//  Created by Hank Liang on 6/24/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    class var sharedInstance: LocationManager {
        dispatch_once(&Inner.token) {
            Inner.instance = LocationManager()
        }
        return Inner.instance!
    }
    
    struct Inner {
        static var instance: LocationManager?
        static var token: dispatch_once_t = 0
    }
    
    let manager = CLLocationManager()
    var allowUseLocation = false
    var currentLocation: CLLocation?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func relocate() {
        currentLocation = nil
        manager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse || status == CLAuthorizationStatus.AuthorizedAlways {
            allowUseLocation = true
        } else {
            // TODO: ask the user to allow the permission
            allowUseLocation = false
            if status == CLAuthorizationStatus.Denied {
                self.showTurnOnLocationServiceAlert()
            }
        }
    }
    
    func showTurnOnLocationServiceAlert() {
        let alert = UIAlertController(title: "温馨提示", message: "美人瑜需要利用您当前的位置信息来更好的帮你展示瑜伽课程，您可以打开当前设备的（设置》隐私》定位服务）来开启定位功能.", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
        alert.addAction(okAction)
        UIApplication.sharedApplication().delegate?.window??.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("didFailWithError:\(error)")
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if currentLocation == nil {
            currentLocation = locations.last as? CLLocation
            manager.stopUpdatingLocation()
            allowUseLocation = true
            NSNotificationCenter.defaultCenter().postNotificationName(MissFitGetLocationSucceeded, object: nil)
        }
    }
}