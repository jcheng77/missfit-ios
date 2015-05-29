//
//  MemberCardInfoViewController.swift
//  missfit
//
//  Created by Hank Liang on 5/29/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class MemberCardInfoViewController: TermsOfUseViewController {
    
    override func getRequestUrl() -> NSURL? {
        return NSURL(string: MissFitMemberCardInfoURI)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
