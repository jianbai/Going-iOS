
//
//  MainTabBarController.swift
//  Going
//
//  Created by scott on 2/4/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let currentUser = PFUser.currentUser()
    let parseConstants: ParseConstants = ParseConstants()

    var isAnimating: Bool = false
    
    var noGender: Bool!
    var noAge: Bool!
    var noHometown: Bool!

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        self.verifyProfileIsComplete()
        
        self.delegate = self
        self.selectedIndex = 1
        self.tabBar.tintColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0)
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        self.tabBar.translucent = false

        self.saveParseInstallation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }
    
    // MARK: - TabBarController Delegate
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        // Get views
        var fromView = tabBarController.selectedViewController!.view
        var toView = viewController.view
        
        // Check if already animating
        if (fromView == toView || self.isAnimating) {
            return false
        }
        self.isAnimating = true

        // Get indices
        var viewControllers = tabBarController.viewControllers as [UIViewController]
        var fromIndex = find(viewControllers, tabBarController.selectedViewController!)!
        var toIndex = find(viewControllers, viewController)!

        // Add destination view
        fromView.superview?.addSubview(toView)
        
        // Get direction of animation
        var scrollRight = toIndex > fromIndex
        
        // Animate
        if (abs(toIndex - fromIndex) > 1) {
            self.animateLong(tabBarController, scrollRight: scrollRight, toIndex: toIndex, fromView: fromView, middleView: viewControllers[1].view, toView: toView)
        } else {
            self.animateShort(tabBarController, scrollRight: scrollRight, toIndex: toIndex, fromView: fromView, middleView: viewControllers[1].view, toView: toView)
        }
        
        return false
    }
    
    // MARK: - Helper Functions
    
    func verifyProfileIsComplete() {
        if (self.isUserProfileIncomplete()) {
            self.currentUser.deleteInBackgroundWithBlock({ (succeeded, error) -> Void in
                if (PFFacebookUtils.session() != nil) {
                    PFFacebookUtils.session().closeAndClearTokenInformation()
                }
                PFUser.logOut()
                
                var loginViewController = self.presentingViewController as LoginViewController
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    loginViewController.login()
                })
                return
            })
        }
    }
    
    func isUserProfileIncomplete() -> Bool {
        self.noGender = self.currentUser.objectForKey(parseConstants.KEY_GENDER) == nil
        self.noAge = self.currentUser.objectForKey(parseConstants.KEY_AGE) == nil
        self.noHometown = self.currentUser.objectForKey(parseConstants.KEY_HOMETOWN) == nil
        
        var missing = self.noGender! || self.noAge! || self.noHometown!
        
        return self.noGender! || self.noAge! || self.noHometown!
    }
    
    func saveParseInstallation() {
        if let installation = PFInstallation.currentInstallation() {
            installation[self.parseConstants.KEY_INSTALLATION_USER_ID] = self.currentUser.objectId
            installation[self.parseConstants.KEY_INSTALLATION_USER_NAME] = self.currentUser[self.parseConstants.KEY_FIRST_NAME] as String
            installation.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
            })
        }
    }
    
    func animateLong(tabBarController: UITabBarController, scrollRight: Bool, toIndex: Int, fromView: UIView, middleView: UIView, toView: UIView) {
        var frameWidth = fromView.frame.size.width
        
        fromView.superview?.addSubview(middleView)
        
        middleView.frame = CGRectMake((scrollRight ? frameWidth : -frameWidth), fromView.frame.origin.y, frameWidth, fromView.frame.size.height)
        toView.frame = CGRectMake((scrollRight ? 2*frameWidth : -2*frameWidth), fromView.frame.origin.y, frameWidth, fromView.frame.size.height)
        
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
    }
    
    func animateShort(tabBarController: UITabBarController, scrollRight: Bool, toIndex: Int, fromView: UIView, middleView: UIView, toView: UIView) {
        var frameWidth = fromView.frame.size.width
        
        toView.frame = CGRectMake((scrollRight ? frameWidth : -frameWidth), fromView.frame.origin.y, frameWidth, fromView.frame.size.height)
        
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
    
}