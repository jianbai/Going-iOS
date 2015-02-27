//
//  ProfilesViewController.swift
//  Going
//
//  Created by scott on 2/9/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit

class ProfilesViewController: UIViewController {

    @IBOutlet weak var memberNameLabel0: UILabel!
    @IBOutlet weak var memberInfoLabel0: UILabel!
    @IBOutlet weak var memberNameLabel1: UILabel!
    @IBOutlet weak var memberInfoLabel1: UILabel!
    @IBOutlet weak var memberNameLabel2: UILabel!
    @IBOutlet weak var memberInfoLabel2: UILabel!
    @IBOutlet weak var reportButton: UIButton!
    
    let parseConstants: ParseConstants = ParseConstants()
    
    var groupMembers: [PFUser] = []

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleReportButton()
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if (segue.identifier == "showReportAbuse") {
            self.title = "Report Abuse"
            var item = self.tabBarController?.tabBar.items![1] as UITabBarItem
            item.title = nil
            self.definesPresentationContext = true
            var profilesViewController = segue.destinationViewController as ProfilesViewController
            profilesViewController.groupMembers = self.groupMembers
            profilesViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: ("exitReportAbuse:"))
//        }
    }
    
    // MARK: - Helper functions
    
    func styleReportButton() {
        self.reportButton.backgroundColor = UIColor.clearColor()
        self.reportButton.layer.cornerRadius = 5
        self.reportButton.layer.borderWidth = 1
        self.reportButton.layer.borderColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0).CGColor
        self.reportButton.tintColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0)
    }
    
    // MARK: - Actions
    
    @IBAction func showReportAbuse() {
        self.performSegueWithIdentifier("showReportAbuse", sender: self)
    }
    
    @IBAction func exitReportAbuse(sender: UIBarButtonItem) {
        self.title = "In this chat"
        var item = self.tabBarController?.tabBar.items![1] as UITabBarItem
        item.title = nil
        
        self.navigationController?.visibleViewController.dismissViewControllerAnimated(true, completion: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: ("showReportAbuse:"))
    }
    
}