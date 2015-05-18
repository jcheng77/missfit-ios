//
//  PaymentViewController.swift
//  missfit
//
//  Created by Hank Liang on 5/19/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {

    @IBAction func backButtonClicked(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
