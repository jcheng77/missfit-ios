//
//  LocationClassesViewController.swift
//  missfit
//
//  Created by Hank Liang on 5/26/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class LocationClassesViewController: AllClassesViewController {
    var missfitLocation: MissFitLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.filterViewConstraintHeight.constant = 0.0
        // Do any additional setup after loading the view.
        super.fetchData(NSDate())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func getClassEndPoint() -> String {
        return MissFitBaseURL + MissFitLocations + "/" + missfitLocation!.locationId + "/" + MissFitClassesURI + MissFitClassesDateURI
    }
    
    override func backButtonClicked(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func addFilter() {
    }
}
