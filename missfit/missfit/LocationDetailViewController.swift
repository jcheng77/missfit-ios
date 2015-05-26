//
//  LocationDetailViewController.swift
//  missfit
//
//  Created by Hank Liang on 4/20/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

enum LocationCategory {
    case Info
    case Class
}

class LocationDetailViewController: UIViewController {
    var missfitLocation: MissFitLocation?
    var currentCategory = LocationCategory.Info
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var classView: UIView!
    @IBOutlet weak var classTableView: UITableView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var currentWeekView: UIView!
    @IBOutlet weak var nextWeekView: UIView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSegments()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func toggleSelection(sender: AnyObject) {
        let segmentedControl = sender as! UISegmentedControl
        if segmentedControl.selectedSegmentIndex == 0 {
            currentCategory = LocationCategory.Info
        } else {
            currentCategory = LocationCategory.Class
        }
        
//        tableView.reloadData()
//        
//        if classes == nil || bookingTeachers == nil {
//            fetchData(currentCategory)
//        }
    }
    
    func initSegments() {
        let optionsArray = ["分店信息", "分店课表"]
        let optionsToggle = UISegmentedControl(items: optionsArray)
        optionsToggle.addTarget(self, action: Selector("toggleSelection:"), forControlEvents: UIControlEvents.ValueChanged)
        optionsToggle.selectedSegmentIndex = 0
        self.navigationItem.titleView = optionsToggle
    }

}
