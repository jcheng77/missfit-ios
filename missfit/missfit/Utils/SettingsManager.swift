//
//  SettingsManager.swift
//  missfit
//
//  Created by Hank Liang on 7/1/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import Foundation

class SettingsManager: NSObject, DOPDropDownMenuDataSource {
    let kFilterColumn = 2
    let kBusinessDistrictIndex = -1
    let kSportCategoryIndex = 0
    let kSmartSortingIndex = 1
    
    class var sharedInstance: SettingsManager {
        dispatch_once(&Inner.token) {
            Inner.instance = SettingsManager()
        }
        return Inner.instance!
    }
    
    struct Inner {
        static var instance: SettingsManager?
        static var token: dispatch_once_t = 0
    }
    
    var businessDistrictArray: [AnyObject] = []
    var sportCategoryArray: [String] = []
    var smartSortingArray: [String] = []
    var memberFee: Float?
    
    override init() {
        super.init()
        self.resetSettings()
        
        if let district = NSUserDefaults.standardUserDefaults().arrayForKey(MissFitBusinessDistrict) {
            businessDistrictArray += district
        }
        
        if let category = NSUserDefaults.standardUserDefaults().arrayForKey(MissFitSportCategory) as? [String] {
            sportCategoryArray += category
        }
        
        self.loadSettings()
    }
    
    func resetSettings() {
        businessDistrictArray = [["name": "全部商区", "areas": ["全部商区"]]]
        sportCategoryArray = ["所有种类"]
        smartSortingArray = ["时间排序", "距离排序"]
    }
    
    func loadSettings() {
        var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        var endpoint: String = MissFitBaseURL + MissFitSettings
        manager.GET(endpoint, parameters: nil, success: { (operation, responseObject) -> Void in
            self.resetSettings()
            self.parseResponseObject(responseObject as! NSDictionary)
            }) { (operation, error) -> Void in
        }
    }
    
    func parseResponseObject(responseObject: NSDictionary) {
        let json = JSON(responseObject)
        for (key: String, subJson: JSON) in json {
            if key == "data" {
                self.memberFee = subJson["member_fee"].floatValue
            }
        }
        if let areas = responseObject.objectForKey("data")?.objectForKey("business_areas") as? [AnyObject] {
            businessDistrictArray += areas
            NSUserDefaults.standardUserDefaults().setObject(areas, forKey: MissFitBusinessDistrict)
        }
        if let category = responseObject.objectForKey("data")?.objectForKey("class_categories") as? [String] {
            sportCategoryArray += category
            NSUserDefaults.standardUserDefaults().setObject(category, forKey: MissFitSportCategory)
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    //MARK: - Filter Menu datasource
    
    func numberOfColumnsInMenu(menu: DOPDropDownMenu!) -> Int {
        return kFilterColumn
    }
    
    func menu(menu: DOPDropDownMenu!, numberOfRowsInColumn column: Int) -> Int {
        if column == kBusinessDistrictIndex {
            return SettingsManager.sharedInstance.businessDistrictArray.count
        } else if column == kSportCategoryIndex {
            return SettingsManager.sharedInstance.sportCategoryArray.count
        } else if column == kSmartSortingIndex {
            return SettingsManager.sharedInstance.smartSortingArray.count
        } else {
            return 0
        }
    }
    
    func menu(menu: DOPDropDownMenu!, titleForRowAtIndexPath indexPath: DOPIndexPath!) -> String! {
        if indexPath.column == kBusinessDistrictIndex {
            return (SettingsManager.sharedInstance.businessDistrictArray[indexPath.row] as! Dictionary<String, AnyObject>) ["name"] as! String
        } else if indexPath.column == kSportCategoryIndex {
            return SettingsManager.sharedInstance.sportCategoryArray[indexPath.row]
        } else if indexPath.column == kSmartSortingIndex {
            return SettingsManager.sharedInstance.smartSortingArray[indexPath.row]
        } else {
            return nil
        }
    }
    
    func menu(menu: DOPDropDownMenu!, numberOfItemsInRow row: Int, column: Int) -> Int {
        if column == kBusinessDistrictIndex {
            return ((SettingsManager.sharedInstance.businessDistrictArray[row] as! Dictionary<String, AnyObject>)["areas"] as! Array<String>).count
        } else {
            return 0
        }
    }
    
    func menu(menu: DOPDropDownMenu!, titleForItemsInRowAtIndexPath indexPath: DOPIndexPath!) -> String! {
        if indexPath.column == 0 {
            return ((SettingsManager.sharedInstance.businessDistrictArray[indexPath.row] as! Dictionary<String, AnyObject>)["areas"] as! Array<String>)[indexPath.item]
        }
        return nil
    }
}