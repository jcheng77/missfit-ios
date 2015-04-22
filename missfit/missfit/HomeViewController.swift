//
//  ViewController.swift
//  missfit
//
//  Created by Hank Liang on 4/13/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var myClassesButton: UIButton!
    @IBOutlet weak var settings: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings.setImage(UIImage(named: "setting")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        settings.tintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func allClassesButtonClicked(sender: AnyObject) {
        let allClassesController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AllClassesViewController") as AllClassesViewController
        presentViewController(UINavigationController(rootViewController: allClassesController), animated: true, completion: nil)
    }

    @IBAction func myClassesButtonClicked(sender: AnyObject) {
        var isUserLogin = false
        if isUserLogin {
        } else {
            var loginViewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as UIViewController
            self.presentViewController(UINavigationController(rootViewController: loginViewController), animated: true, completion: nil)
        }
    }

    @IBAction func allTeachersButtonClicked(sender: AnyObject) {
        let allTeachersController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AllTeachersViewController") as AllTeachersViewController
        presentViewController(UINavigationController(rootViewController: allTeachersController), animated: true, completion: nil)
    }
}

