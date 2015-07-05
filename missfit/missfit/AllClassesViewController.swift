//
//  AllClassesViewController.swift
//  missfit
//
//  Created by Hank Liang on 4/14/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class AllClassesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DOPDropDownMenuDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var currentWeekView: UIView!
    @IBOutlet weak var nextWeekView: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterViewConstraintHeight: NSLayoutConstraint!
    
    
    var classes = [MissFitClass]()
    var datesPageIndex = 0
    var selectedDateIndice: (datesPageIndex: Int, dateIndex:Int) = (0, 0)
    var todayDateIndice: (datesPageIndex: Int, dateIndex:Int) = (0, 0)
    var buttonsCreated: Bool = false
    var currentWeekViews = [UIView]()
    var nextWeekViews = [UIView]()
    var currentWeekDates = [NSDate]()
    var nextWeekDates = [NSDate]()
    let weekdaysArray: [String] = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
    
    let kDateBackgroundViewTag = 100
    let kWeekDayLabelTag = 101
    let kDayLabelTag = 102
    var currentFilterIndice: (category: Int, smartSorting: Int) = (0, 0)
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func leftButtonClicked(sender: AnyObject) {
        if datesPageIndex <= 0 {
            // Do nothing
        } else {
            datesPageIndex--
            currentWeekView.hidden = false
            nextWeekView.hidden = true
        }
    }
    
    @IBAction func rightButtonClicked(sender: AnyObject) {
        if datesPageIndex > 0 {
            // Do nothing
        } else {
            datesPageIndex++
            currentWeekView.hidden = true
            nextWeekView.hidden = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.filterViewConstraintHeight.constant = 44.0
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("startLoadData"), name: MissFitLoadWeeklyClasses, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("loadMembershipSucceededCallback"), name: MissFitLoadMembershipSucceededCallback, object: nil)
        // Add the filter menu
        self.addFilter()
    }
    
    func addFilter() {
        let menu = DOPDropDownMenu(origin: self.view.frame.origin, andHeight: self.filterView.frame.height)
        menu.delegate = self
        menu.dataSource = SettingsManager.sharedInstance
        menu.indicatorColor = MissFitTheme.theme.colorPink
        menu.textSelectedColor = MissFitTheme.theme.colorPink
        self.view.addSubview(menu)
        self.view.bringSubviewToFront(menu)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func startLoadData() {
        if classes.count <= 0 {
            self.refreshData()
        }
    }
    
    func refreshData() {
        if self.selectedDateIndice.datesPageIndex == 0 {
            // Current week's classes
            self.fetchData(self.currentWeekDates[self.selectedDateIndice.dateIndex])
        } else {
            // Next week's classes
            self.fetchData(self.nextWeekDates[self.selectedDateIndice.dateIndex])
        }
    }
    
    func loadMembershipSucceededCallback() {
        if MissFitUser.user.hasMonthlyCard && !MissFitUser.user.isMonthlyCardExpired() {
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        createDatesButtons()
        if tableView.pullToRefreshView == nil {
            tableView.addPullToRefreshWithAction({ [weak self] in
                self?.refreshData()
                }, withAnimator: BeatAnimator())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func currentWeekButtonClicked(sender: UITapGestureRecognizer) {
        for var i = 0; i < currentWeekViews.count; i++ {
            if sender.view! == currentWeekViews[i] && !(selectedDateIndice.datesPageIndex == 0 && selectedDateIndice.dateIndex == i) {
                selectedDateIndice = (0, i)
                // call api
                fetchData(currentWeekDates[i])
                break
            }
        }
        updateDatesButton()
    }
    
    func nextWeekButtonClicked(sender: UITapGestureRecognizer) {
        for var i = 0; i < nextWeekViews.count; i++ {
            if sender.view! == nextWeekViews[i] && !(selectedDateIndice.datesPageIndex == 1 && selectedDateIndice.dateIndex == i) {
                selectedDateIndice = (1, i)
                // call api
                fetchData(nextWeekDates[i])
                break
            }
        }
        updateDatesButton()
    }
    
    func createDatesButtons() {
        if !buttonsCreated {
            let currentDate = NSDate()
            let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            var components = gregorianCalendar?.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitWeekday | .CalendarUnitWeekOfYear, fromDate: currentDate)
            // Default the selected date is today
            selectedDateIndice = (0, components!.weekday - 1)
            todayDateIndice = selectedDateIndice
            datesPageIndex = selectedDateIndice.datesPageIndex
            
            let dt = NSDateComponents()
            dt.weekOfYear = components!.weekOfYear
            dt.month = components!.month
            dt.year = components!.year
            
            let width = currentWeekView.bounds.size.width / 7
            let height = currentWeekView.bounds.size.height
            
            let dateBackgroundDiameter = min(width, height) - 1
            
            for var i = 1 ; i <= 7; i++ {
                dt.weekday = i
                var date = gregorianCalendar?.dateFromComponents(dt)
                currentWeekDates.append(date!)
                var dayComponents = gregorianCalendar?.components(.CalendarUnitDay, fromDate: date!)
                
                let dateView = UIView(frame: CGRectMake((CGFloat)(i - 1) * width, 0, width, height))
                let tapGesture = UITapGestureRecognizer(target: self, action: Selector("currentWeekButtonClicked:"))
                dateView.addGestureRecognizer(tapGesture)
                currentWeekViews.append(dateView)
                currentWeekView.addSubview(dateView)
                
                let dateBackground = UIView(frame: CGRectMake(0, 0, dateBackgroundDiameter, dateBackgroundDiameter))
                dateBackground.tag = kDateBackgroundViewTag
                dateBackground.backgroundColor = MissFitTheme.theme.colorPink
                dateBackground.center = CGPointMake(dateView.bounds.width / 2, dateView.bounds.height / 2)
                dateBackground.layer.cornerRadius = dateBackground.bounds.width / 2
                dateView.addSubview(dateBackground)
                
                let weekdayLabel = UILabel(frame: CGRectMake(0, 0, width * 0.7, height * 0.45))
                weekdayLabel.tag = kWeekDayLabelTag
                weekdayLabel.text = weekdaysArray[i - 1]
                weekdayLabel.font = UIFont.systemFontOfSize(12)
                weekdayLabel.textAlignment = .Center
                weekdayLabel.center = CGPointMake(dateView.bounds.width / 2, dateView.bounds.height / 2 - 8)
                dateView.addSubview(weekdayLabel)
                
                let dayLabel = UILabel(frame: CGRectMake(0, 0, width * 0.7, height * 0.45))
                dayLabel.tag = kDayLabelTag
                dayLabel.text = "\(dayComponents!.day)"
                dayLabel.font = UIFont.systemFontOfSize(14)
                dayLabel.textAlignment = .Center
                dayLabel.center = CGPointMake(dateView.bounds.width / 2, dateView.bounds.height / 2 + 8)
                dateView.addSubview(dayLabel)
            }
            
            let nextweek = NSDate(timeInterval: 7 * 24 * 3600, sinceDate: currentDate)
            components = gregorianCalendar?.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitWeekday | .CalendarUnitWeekOfYear, fromDate: nextweek)
            
            dt.weekOfYear = components!.weekOfYear
            dt.month = components!.month
            dt.year = components!.year
            
            for var i = 1 ; i <= 7; i++ {
                dt.weekday = i
                var date = gregorianCalendar?.dateFromComponents(dt)
                nextWeekDates.append(date!)
                var dayComponents = gregorianCalendar?.components(.CalendarUnitDay, fromDate: date!)
                let dateView = UIView(frame: CGRectMake((CGFloat)(i - 1) * width, 0, width, height))
                let tapGesture = UITapGestureRecognizer(target: self, action: Selector("nextWeekButtonClicked:"))
                dateView.addGestureRecognizer(tapGesture)
                nextWeekViews.append(dateView)
                nextWeekView.addSubview(dateView)
                
                let dateBackground = UIView(frame: CGRectMake(0, 0, dateBackgroundDiameter, dateBackgroundDiameter))
                dateBackground.tag = kDateBackgroundViewTag
                dateBackground.backgroundColor = MissFitTheme.theme.colorPink
                dateBackground.center = CGPointMake(dateView.bounds.width / 2, dateView.bounds.height / 2)
                dateBackground.layer.cornerRadius = dateBackground.bounds.width / 2
                dateView.addSubview(dateBackground)
                
                let weekdayLabel = UILabel(frame: CGRectMake(0, 0, width * 0.7, height * 0.45))
                weekdayLabel.tag = kWeekDayLabelTag
                weekdayLabel.text = weekdaysArray[i - 1]
                weekdayLabel.font = UIFont.systemFontOfSize(12)
                weekdayLabel.textAlignment = .Center
                weekdayLabel.center = CGPointMake(dateView.bounds.width / 2, dateView.bounds.height / 2 - 8)
                dateView.addSubview(weekdayLabel)
                
                let dayLabel = UILabel(frame: CGRectMake(0, 0, width * 0.7, height * 0.45))
                dayLabel.tag = kDayLabelTag
                dayLabel.text = "\(dayComponents!.day)"
                dayLabel.font = UIFont.systemFontOfSize(14)
                dayLabel.textAlignment = .Center
                dayLabel.center = CGPointMake(dateView.bounds.width / 2, dateView.bounds.height / 2 + 8)
                dateView.addSubview(dayLabel)
            }
            
            nextWeekView.hidden = true
            buttonsCreated = true
            updateDatesButton()
        }
    }
    
    func updateDatesButton() {
        for var i = 0; i < currentWeekViews.count; i++ {
            if selectedDateIndice.datesPageIndex == 1 {
                currentWeekViews[i].viewWithTag(kDateBackgroundViewTag)?.backgroundColor = UIColor.clearColor()
                if todayDateIndice.dateIndex == i {
                    (currentWeekViews[i].viewWithTag(kWeekDayLabelTag) as? UILabel)?.textColor = MissFitTheme.theme.colorPink
                    (currentWeekViews[i].viewWithTag(kDayLabelTag) as? UILabel)?.textColor = MissFitTheme.theme.colorPink
                } else {
                    (currentWeekViews[i].viewWithTag(kWeekDayLabelTag) as? UILabel)?.textColor = MissFitTheme.theme.colorDarkText
                    (currentWeekViews[i].viewWithTag(kDayLabelTag) as? UILabel)?.textColor = MissFitTheme.theme.colorDarkText
                }

            } else {
                if selectedDateIndice.dateIndex == i {
                    currentWeekViews[i].viewWithTag(kDateBackgroundViewTag)?.backgroundColor = MissFitTheme.theme.colorPink
                    (currentWeekViews[i].viewWithTag(kWeekDayLabelTag) as? UILabel)?.textColor = UIColor.whiteColor()
                    (currentWeekViews[i].viewWithTag(kDayLabelTag) as? UILabel)?.textColor = UIColor.whiteColor()
                } else if todayDateIndice.dateIndex == i && selectedDateIndice.dateIndex != todayDateIndice.dateIndex {
                    currentWeekViews[i].viewWithTag(kDateBackgroundViewTag)?.backgroundColor = UIColor.clearColor()
                    (currentWeekViews[i].viewWithTag(kWeekDayLabelTag) as? UILabel)?.textColor = MissFitTheme.theme.colorPink
                    (currentWeekViews[i].viewWithTag(kDayLabelTag) as? UILabel)?.textColor = MissFitTheme.theme.colorPink
                } else {
                    currentWeekViews[i].viewWithTag(kDateBackgroundViewTag)?.backgroundColor = UIColor.clearColor()
                    (currentWeekViews[i].viewWithTag(kWeekDayLabelTag) as? UILabel)?.textColor = MissFitTheme.theme.colorDarkText
                    (currentWeekViews[i].viewWithTag(kDayLabelTag) as? UILabel)?.textColor = MissFitTheme.theme.colorDarkText
                }
            }
        }
        
        for var i = 0; i < nextWeekViews.count; i++ {
            if selectedDateIndice.datesPageIndex == 0 {
                nextWeekViews[i].viewWithTag(kDateBackgroundViewTag)?.backgroundColor = UIColor.clearColor()
                (nextWeekViews[i].viewWithTag(kWeekDayLabelTag) as? UILabel)?.textColor = MissFitTheme.theme.colorDarkText
                (nextWeekViews[i].viewWithTag(kDayLabelTag) as? UILabel)?.textColor = MissFitTheme.theme.colorDarkText
                
            } else {
                if selectedDateIndice.dateIndex == i {
                    nextWeekViews[i].viewWithTag(kDateBackgroundViewTag)?.backgroundColor = MissFitTheme.theme.colorPink
                    (nextWeekViews[i].viewWithTag(kWeekDayLabelTag) as? UILabel)?.textColor = UIColor.whiteColor()
                    (nextWeekViews[i].viewWithTag(kDayLabelTag) as? UILabel)?.textColor = UIColor.whiteColor()
                } else {
                    nextWeekViews[i].viewWithTag(kDateBackgroundViewTag)?.backgroundColor = UIColor.clearColor()
                    (nextWeekViews[i].viewWithTag(kWeekDayLabelTag) as? UILabel)?.textColor = MissFitTheme.theme.colorDarkText
                    (nextWeekViews[i].viewWithTag(kDayLabelTag) as? UILabel)?.textColor = MissFitTheme.theme.colorDarkText
                }
            }
        }
    }
    
    func parseResponseObject(responseObject: NSDictionary) {
        let json = JSON(responseObject)
        for (key: String, subJson: JSON) in json {
            if key == "data" {
                for (index: String, thirdJson: JSON) in subJson {
                    let missfitClass: MissFitClass = MissFitClass(json: thirdJson)
                    classes.append(missfitClass)
                }
            }
        }
    }
    
    func getClassEndPoint() -> String {
        return MissFitBaseURL + MissFitClassesURI + MissFitClassesDateURI
    }

    func fetchData(date: NSDate) {
        classes.removeAll(keepCapacity: false)
        var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        let dateString = MissFitUtils.formatDate(date)
        var endpoint: String = getClassEndPoint() + dateString
        
        if currentFilterIndice.category != 0 {
            endpoint += "&" + MissFitCategory + SettingsManager.sharedInstance.sportCategoryArray[currentFilterIndice.category]
        }
        
        if currentFilterIndice.smartSorting != 0 {
            if LocationManager.sharedInstance.allowUseLocation && LocationManager.sharedInstance.currentLocation != nil {
                endpoint += "&" + MissFitLocationQueryURI + "\(LocationManager.sharedInstance.currentLocation!.coordinate.longitude),\(LocationManager.sharedInstance.currentLocation!.coordinate.latitude)"
            }
        }
        
        endpoint = endpoint.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!

        if MissFitUser.user.isLogin {
            manager.requestSerializer.setValue(MissFitUser.user.userId, forHTTPHeaderField: "X-User-Id")
            manager.requestSerializer.setValue(MissFitUser.user.token, forHTTPHeaderField: "X-Auth-Token")
        }
        KVNProgress.show()
        manager.GET(endpoint, parameters: nil, success: { (operation, responseObject) -> Void in
//            KVNProgress.showSuccessWithStatus("获取课程列表成功！")
            KVNProgress.dismiss()
            // Parse data
            self.parseResponseObject(responseObject as! NSDictionary)
            self.tableView.reloadData()
            self.tableView.stopPullToRefresh()
            }) { (operation, error) -> Void in
                if error.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil {
                    // Need to get the status and message
                    let json = JSON(data: error.userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData)
                    let message: String? = json["message"].string
                    KVNProgress.showErrorWithStatus(message)
                } else {
                    KVNProgress.showErrorWithStatus("获取课程列表失败")
                }
                self.tableView.stopPullToRefresh()
        }
    }
    
    func loadMoreData(page: Int) {
        
    }
    
    //MARK: - Table view delegate and datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ClassTableViewCell", forIndexPath: indexPath) as! ClassTableViewCell
        cell.setData(self.classes[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 94.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UmengHelper.event(AnalyticsClickClassDetail)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let classDetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ClassDetailViewController") as! ClassDetailViewController
        classDetailController.missfitClass = classes[indexPath.row]
        navigationController?.pushViewController(classDetailController, animated: true)
    }
    
    //MARK: - Filter Menu delegate

    
    func menu(menu: DOPDropDownMenu!, didSelectRowAtIndexPath indexPath: DOPIndexPath!) {
        if indexPath.column == SettingsManager.sharedInstance.kSportCategoryIndex {
            if indexPath.row != currentFilterIndice.category {
                currentFilterIndice.category = indexPath.row
                self.refreshData()
            }
        } else if indexPath.column == SettingsManager.sharedInstance.kSmartSortingIndex {
            if indexPath.row != currentFilterIndice.smartSorting {
                currentFilterIndice.smartSorting = indexPath.row
                self.refreshData()
            }
        }
    }
}
