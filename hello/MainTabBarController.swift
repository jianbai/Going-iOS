
//
//  MainTabBarController.swift
//  hello
//
//  Created by scott on 2/4/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let currentUser = PFUser.currentUser()
    let parseConstants: ParseConstants = ParseConstants()
    var isAnimating: Bool = false
    
    override func viewDidLoad() {
        self.delegate = self
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }
//    
//    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        
//    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        // Get views
        var fromView = tabBarController.selectedViewController!.view
        var toView = viewController.view
        if (fromView == toView || self.isAnimating) {
            return false
        }
        self.isAnimating = true
        
        var viewControllers = tabBarController.viewControllers as [UIViewController]

        var fromIndex = find(viewControllers, tabBarController.selectedViewController!)!
        var toIndex = find(viewControllers, viewController)!
        
        // Get size of view area
        var fromViewFrame = fromView.frame
        var frameWidth = fromViewFrame.size.width
        var scrollRight = toIndex > fromIndex
        
        fromView.superview?.addSubview(toView)
        
        if (abs(toIndex - fromIndex) > 1) {
            var middleView = viewControllers[1].view
            fromView.superview?.addSubview(middleView)
            
            middleView.frame = CGRectMake((scrollRight ? frameWidth : -frameWidth), fromViewFrame.origin.y, frameWidth, fromViewFrame.size.height)
            toView.frame = CGRectMake((scrollRight ? 2*frameWidth : -2*frameWidth), fromViewFrame.origin.y, frameWidth, fromViewFrame.size.height)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                toView.frame.origin.x += (scrollRight ? -2*frameWidth : 2*frameWidth)
                middleView.frame.origin.x += (scrollRight ? -2*frameWidth : 2*frameWidth)
                fromView.frame.origin.x += (scrollRight ? -2*frameWidth : 2*frameWidth)
            }, completion: { (finished) -> Void in
                if (finished) {
                    self.isAnimating = false
                    tabBarController.selectedIndex = toIndex
                }
            })
        } else {
            toView.frame = CGRectMake((scrollRight ? frameWidth : -frameWidth), fromViewFrame.origin.y, frameWidth, fromViewFrame.size.height)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                toView.frame.origin.x += (scrollRight ? -frameWidth : frameWidth)
                fromView.frame.origin.x += (scrollRight ? -frameWidth : frameWidth)
                
                }) { (finished) -> Void in
                    if (finished) {
                        self.isAnimating = false
                        tabBarController.selectedIndex = toIndex
                    }
            }
        }
        
        return false
    }
    
}