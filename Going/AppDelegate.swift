//
//  AppDelegate.swift
//  Going
//
//  Created by scott on 1/27/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

// TODO: Refactor

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Enable Parse local data store
        Parse.enableLocalDatastore()
        
        // Initialize Parse
        Parse.setApplicationId("BgVWp9cm22GjjGzt6Qj9v9TDYaAQaCIYR6Fe8y2j",
            clientKey: "FPQS5IsBfyNv4CJz5DH4FlCUtELeIeJkMbE6Q6g3")
        
        // Initialize Parse Push Notifications
        var userNotificationTypes: UIUserNotificationType = (UIUserNotificationType.Alert |
                                                            UIUserNotificationType.Badge |
                                                            UIUserNotificationType.Sound)
        var settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        // Initialize Facebook
        PFFacebookUtils.initializeFacebook()
        
        // Reset badge count when app is opened
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        // Custom status bar style
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String,
        annotation: AnyObject?) -> Bool {
        return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication,
                withSession:PFFacebookUtils.session())
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        var currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.channels = [""]
        currentInstallation.saveInBackgroundWithBlock { (succeeded, error) -> Void in
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        PFFacebookUtils.session().close()
    }


}

