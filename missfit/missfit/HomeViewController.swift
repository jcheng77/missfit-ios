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
        if MissFitUser.user.isLogin {
            let myClassesController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MyClassesViewController") as MyClassesViewController
            presentViewController(UINavigationController(rootViewController: myClassesController), animated: true, completion: nil)
        } else {
            let loginController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as UIViewController
            presentViewController(UINavigationController(rootViewController: loginController), animated: true, completion: nil)
        }
    }

    @IBAction func allTeachersButtonClicked(sender: AnyObject) {
        let allTeachersController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AllTeachersViewController") as AllTeachersViewController
        presentViewController(UINavigationController(rootViewController: allTeachersController), animated: true, completion: nil)
    }
    
    @IBAction func settingsButtonClicked(sender: AnyObject) {
        if MissFitUser.user.isLogin {
            let settingsController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SettingsViewController") as UIViewController
            presentViewController(UINavigationController(rootViewController: settingsController), animated: true, completion: nil)
        } else {
            let loginController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as UIViewController
            presentViewController(UINavigationController(rootViewController: loginController), animated: true, completion: nil)
        }
    }
    
}

