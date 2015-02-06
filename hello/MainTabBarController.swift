
//
//  MainTabBarController.swift
//  hello
//
//  Created by scott on 2/4/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        self.selectedIndex = 1
        self.tabBar.tintColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0)
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        self.tabBar.translucent = false
    }
    
}