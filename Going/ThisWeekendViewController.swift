//
//  ThisWeekendViewController.swift
//  Going
//
//  Created by scott on 1/27/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class ThisWeekendViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var meetLabel: UILabel!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var goActivityIndicator: UIActivityIndicatorView!
    
    let parseConstants: ParseConstants = ParseConstants()
    let firebaseConstants: FirebaseConstants = FirebaseConstants()
    let currentUser: PFUser = PFUser.currentUser()
    let locationManager: CLLocationManager = CLLocationManager()
    let ref: Firebase = Firebase(url: FirebaseConstants().URL_USERS)
        .childByAppendingPath(PFUser.currentUser().objectId)
        .childByAppendingPath(FirebaseConstants().KEY_MATCHED)
    var currentLocation: CLLocation?
    var groupChatRef: Firebase!
    var memberIds: [String]!
    var groupMembers: [PFUser] = []
    var groupMembersRelation: PFRelation!
    var isSearching: Bool = false
    
    var loadingScreen: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingScreen = NSBundle.mainBundle().loadNibNamed("Loading", owner: self, options: nil)[0] as UIView
        loadingScreen.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.view.addSubview(loadingScreen)

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        self.view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 18)!,
            NSForegroundColorAttributeName: UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)]
        
        self.groupMembersRelation = self.currentUser.relationForKey(self.parseConstants.KEY_GROUP_MEMBERS_RELATION)
        var isMatched = self.currentUser[parseConstants.KEY_IS_MATCHED] as Bool
        var matchDialogSeen = self.currentUser[parseConstants.KEY_MATCH_DIALOG_SEEN] as Bool
        
        if (isMatched) {
            matchDialogSeen ? self.segueWithGroupMembers("showGroupChat") : self.segueWithGroupMembers("showMatchMade")
        } else {
            loadingScreen.removeFromSuperview()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.isSearching = self.currentUser[parseConstants.KEY_IS_SEARCHING] as Bool
        
        if (self.isSearching) {
            self.showActivityIndicator()
            self.startObserver()
            self.triggerLocationServices()
        } else {
            self.hideActivityIndicator()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isSearching) {
            NSLog("DISAPPEAR OBSERVERS")
            self.ref.removeAllObservers()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if (segue.identifier == "showMatchMade") {
            self.definesPresentationContext = true
            self.title = "Match Made!"
            var item = self.tabBarController?.tabBar.items![1] as UITabBarItem
            item.title = nil
            var matchMadeViewController = segue.destinationViewController as MatchMadeViewController
            matchMadeViewController.groupMembers = self.groupMembers
            matchMadeViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        } else if (segue.identifier == "showGroupChat") {
            var groupChatViewController = segue.destinationViewController as GroupChatViewController
            groupChatViewController.groupMembers = self.groupMembers
        } else if (segue.identifier == "showHelp") {
            segue.destinationViewController.navigationBar.tintColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        }
    }
    
    func startObserver() {
        NSLog("START OBSERVER")
        self.ref.observeEventType(.Value, withBlock: { (snapshot) -> Void in
            var isMatched = snapshot.value as Bool
            if (isMatched) {
                self.onMatchMade()
            }
        })
    }
    
    func onMatchMade() {
        NSLog("MATCH MADE")
        self.ref.removeAllObservers()

        
        self.isSearching = false
        self.currentUser[parseConstants.KEY_IS_SEARCHING] = false
        self.currentUser[parseConstants.KEY_IS_MATCHED] = true
        self.currentUser.saveInBackgroundWithBlock { (succeeded, error) -> Void in
        }
        
        self.segueWithGroupMembers("showMatchMade")
    }
    
    func segueWithGroupMembers(identifier: String) {
        var query = PFQuery(className: self.parseConstants.CLASS_GROUPS)
        query.whereKey(self.parseConstants.KEY_GROUP_MEMBER_IDS, equalTo: self.currentUser.objectId)
        query.getFirstObjectInBackgroundWithBlock { (group, error) -> Void in
            self.groupChatRef = Firebase(url: self.firebaseConstants.URL_GROUP_CHATS).childByAppendingPath(group.objectId)
            self.memberIds = group[self.parseConstants.KEY_GROUP_MEMBER_IDS] as [String]
            for member in self.memberIds {
                if (member != self.currentUser.objectId) {
                    var user = PFUser.query().getObjectWithId(member) as PFUser
                    self.groupMembers.append(user)
                    self.groupMembersRelation.addObject(user)
                }
            }
            self.currentUser[self.parseConstants.KEY_GROUP_ID] = group.objectId
            self.currentUser.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
            })
            
            if let installation = PFInstallation.currentInstallation() {
                installation[self.parseConstants.KEY_INSTALLATION_GROUP_ID] = group.objectId
                installation.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                })
            }
            
            self.performSegueWithIdentifier(identifier, sender: self)
        }
    }
    
    func showActivityIndicator() {
        self.goActivityIndicator.startAnimating()
        self.goActivityIndicator.hidden = false
        self.goButton.setTitle("", forState: UIControlState.Normal)
        self.meetLabel.text = "Searching..."
    }
    
    func hideActivityIndicator() {
        self.goActivityIndicator.hidden = true
        self.goActivityIndicator.stopAnimating()
        self.goButton.setTitle("Go", forState: UIControlState.Normal)
        self.meetLabel.text = "Meet 3 people this weekend"
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        NSLog("DID CHANGE STATUS")
        switch (status) {
        case .NotDetermined, .Restricted, .Denied:
            NSLog("STATUS RESTRICTED OR DENIED")
            let alertController = UIAlertController(
                title: "Location Access Disabled",
                message: "Going requires location services to make sure people are actually close enough to each other to meet. Please open this app's settings and enable location services -- it'll be a lot more fun!",
                preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                self.hideActivityIndicator()
                self.isSearching = false
                self.currentUser[self.parseConstants.KEY_IS_SEARCHING] = false
                self.currentUser.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                })
            }
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                    self.hideActivityIndicator()
                    self.isSearching = false
                    self.currentUser[self.parseConstants.KEY_IS_SEARCHING] = false
                    self.currentUser.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                    })
                }
            }
            alertController.addAction(openAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            break
        default:
            NSLog("STATUS SOMETHING ELSE")
            self.getCurrentLocation()
        }
    }
    
    func triggerLocationServices() {
        NSLog("TRIGGERD")
        if CLLocationManager.locationServicesEnabled() {
            NSLog("LS ENABLED")
            if self.locationManager.respondsToSelector("requestWhenInUseAuthorization") {
                NSLog("RESPONDING")
                self.checkLocationAuthorizationStatus()
            } else {
                NSLog("NOT RESPONDING")
                self.getCurrentLocation()
            }
        }
    }
    
    func checkLocationAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .NotDetermined:
            NSLog("STATUS NOT DETERMINED")
            self.locationManager.requestWhenInUseAuthorization()
            break
        case .Restricted, .Denied:
            NSLog("STATUS RESTRICTED OR DENIED")
            let alertController = UIAlertController(
                title: "Location Access Disabled",
                message: "Going requires location services to make sure people are actually close enough to each other to meet. Please open this app's settings and enable location services -- it'll be a lot more fun!",
                preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                self.hideActivityIndicator()
                self.isSearching = false
                self.currentUser[self.parseConstants.KEY_IS_SEARCHING] = false
                self.currentUser.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                })
            }
            alertController.addAction(cancelAction)

            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                    self.hideActivityIndicator()
                    self.isSearching = false
                    self.currentUser[self.parseConstants.KEY_IS_SEARCHING] = false
                    self.currentUser.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                    })
                }
            }
            alertController.addAction(openAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            break
        default:
            NSLog("STATUS SOMETHING ELSE")
            self.getCurrentLocation()
        }
    }
    
    func getCurrentLocation() {
        NSLog("STARTING LOCATION UPDATES")
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        NSLog("DID UPDATE LOCATIONS")
        self.currentLocation = self.locationManager.location
        self.locationManager.stopUpdatingLocation()
        self.currentUser[parseConstants.KEY_LATITUDE] = self.currentLocation?.coordinate.latitude
        self.currentUser[parseConstants.KEY_LONGITUDE] = self.currentLocation?.coordinate.longitude
        self.currentUser.saveInBackgroundWithBlock { (succeeded, error) -> Void in
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func go() {
        if (!self.isSearching) {
            self.showActivityIndicator()
            self.triggerLocationServices()
            self.startObserver()
            self.isSearching = true
            self.currentUser[parseConstants.KEY_IS_SEARCHING] = true
            self.currentUser.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
            })
            NSLog("GOGOGO")
        }
    }
    
    @IBAction func showHelp() {
        self.performSegueWithIdentifier("showHelp", sender: self)
    }
    
}