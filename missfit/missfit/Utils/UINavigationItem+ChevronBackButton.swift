//
//  UINavigationItem+ChevronBackButton.swift
//  missfit
//
//  Created by Hank Liang on 4/22/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import Foundation

extension UINavigationItem {
    func backBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
}