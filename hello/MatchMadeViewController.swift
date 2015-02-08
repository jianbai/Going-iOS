//
//  MatchMadeViewController.swift
//  hello
//
//  Created by scott on 2/8/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit

class MatchMadeViewController: UIViewController {
    @IBOutlet weak var memberNameLabel0: UILabel!
    @IBOutlet weak var memberInfoLabel0: UILabel!
    @IBOutlet weak var memberNameLabel1: UILabel!
    @IBOutlet weak var memberInfoLabel1: UILabel!
    @IBOutlet weak var memberNameLabel2: UILabel!
    @IBOutlet weak var memberInfoLabel2: UILabel!
    
    let parseConstants: ParseConstants = ParseConstants()
    let currentUser: PFUser = PFUser.currentUser()
    var groupMembers: [PFUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.groupMembers.count != 3) {
            getGroupMembers()
        }
        
        var memberNames: [UILabel] = [self.memberNameLabel0, self.memberNameLabel1, self.memberNameLabel2]
        var memberInfo: [UILabel] = [self.memberInfoLabel0, self.memberInfoLabel1, self.memberInfoLabel2]
        
        for var i=0; i<3; ++i {
            var member: PFUser = self.groupMembers[i]
            var memberAge = member[parseConstants.KEY_AGE]! as String
            var memberHometown = member[parseConstants.KEY_HOMETOWN]! as String
            var memberInfoText = memberAge + "  : :  " + memberHometown
            
            memberNames[i].text = member[parseConstants.KEY_FIRST_NAME] as? String
            memberInfo[i].text = memberInfoText
        }
    }
    
    func getGroupMembers() {
        var query = PFQuery(className: self.parseConstants.CLASS_GROUPS)
        query.whereKey(self.parseConstants.KEY_GROUP_MEMBER_IDS, equalTo: self.currentUser.objectId)
        query.getFirstObjectInBackgroundWithBlock { (group, error) -> Void in
            var memberIds = group[self.parseConstants.KEY_GROUP_MEMBER_IDS] as [String]
            for member in memberIds {
                if (member != self.currentUser.objectId) {
                    var user = PFUser.query().getObjectWithId(member) as PFUser
                    self.groupMembers.append(user)
                    self.currentUser.relationForKey(self.parseConstants.KEY_GROUP_MEMBERS_RELATION).addObject(user)
                }
            }
            self.currentUser[self.parseConstants.KEY_GROUP_ID] = group.objectId
            self.currentUser.save()
        }
    }
    
    @IBAction func sayHello() {
        let nav = self.presentingViewController! as UINavigationController
        let thisWeekendViewController = nav.visibleViewController as UIViewController
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            thisWeekendViewController.performSegueWithIdentifier("showGroupChat", sender: thisWeekendViewController)
        })
    }
}