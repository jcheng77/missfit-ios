//
//  TeacherClassesViewController.swift
//  missfit
//
//  Created by Hank Liang on 5/17/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class TeacherClassesViewController: AllClassesViewController {
    var teacherInfo: MissFitTeacher?

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
        return MissFitBaseURL + MissFitTeachersURI + "/" + teacherInfo!.teacherId + "/" + MissFitClassesURI + MissFitClassesDateURI
    }
    
    override func backButtonClicked(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func addFilter() {
    }
}
