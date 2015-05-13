//
//  TermsOfUseViewController.swift
//  missfit
//
//  Created by Hank Liang on 5/13/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class TermsOfUseViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let touUrl = NSURL(string: MissFitTermsOfUseURI)
        let request = NSURLRequest(URL: touUrl!)
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
