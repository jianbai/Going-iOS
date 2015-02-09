
//
//  MainTabBarController.swift
//  hello
//
//  Created by scott on 2/4/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let currentUser = PFUser.currentUser()
    let parseConstants: ParseConstants = ParseConstants()
    
    override func viewDidLoad() {
        self.selectedIndex = 1
        self.tabBar.tintColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0)
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        self.tabBar.translucent = false
        
        if let installation = PFInstallation.currentInstallation() {
            installation[self.parseConstants.KEY_INSTALLATION_USER_ID] = self.currentUser.objectId
            installation[self.parseConstants.KEY_INSTALLATION_USER_NAME] = self.currentUser[self.parseConstants.KEY_FIRST_NAME] as String
            installation.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
            })
        }
    }
    
}