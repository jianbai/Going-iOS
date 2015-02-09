//
//  ThisWeekendViewController.swift
//  hello
//
//  Created by scott on 1/27/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit

class ThisWeekendViewController: UIViewController {
    @IBOutlet weak var meetLabel: UILabel!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var goActivityIndicator: UIActivityIndicatorView!
    
    let parseConstants: ParseConstants = ParseConstants()
    let firebaseConstants: FirebaseConstants = FirebaseConstants()
    let currentUser: PFUser = PFUser.currentUser()
    let ref: Firebase = Firebase(url: FirebaseConstants().URL_USERS)
        .childByAppendingPath(PFUser.currentUser().objectId)
        .childByAppendingPath(FirebaseConstants().KEY_MATCHED)
    var groupChatRef: Firebase!
    var memberIds: [String]!
    var groupMembers: [PFUser] = []
    var groupMembersRelation: PFRelation!
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 18)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.groupMembersRelation = self.currentUser.relationForKey(self.parseConstants.KEY_GROUP_MEMBERS_RELATION)
        var isMatched = self.currentUser[parseConstants.KEY_IS_MATCHED] as Bool
        
        if (isMatched) {
            self.segueWithGroupMembers("showGroupChat")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.isSearching = self.currentUser[parseConstants.KEY_IS_SEARCHING] as Bool
        
        if (self.isSearching) {
            self.showActivityIndicator()
            self.startObserver()
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
            var matchMadeViewController = segue.destinationViewController as MatchMadeViewController
            matchMadeViewController.groupMembers = self.groupMembers
            matchMadeViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        } else if (segue.identifier == "showGroupChat") {
            var groupChatViewController = segue.destinationViewController as GroupChatViewController
            groupChatViewController.groupMembers = self.groupMembers
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
        self.hideActivityIndicator()
        
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
    
    // MARK: - IBActions
    
    @IBAction func go() {
        if (!self.isSearching) {
            self.startObserver()
            self.showActivityIndicator()
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