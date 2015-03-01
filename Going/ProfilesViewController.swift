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
    
    var currentUser: PFUser!
    var groupMembers: [PFUser] = []
    var names: [String] = ["", "", ""]

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentUser = PFUser.currentUser()
        
        self.styleReportButton()
        
        var memberNames: [UILabel] = [self.memberNameLabel0, self.memberNameLabel1, self.memberNameLabel2]
        var memberInfo: [UILabel] = [self.memberInfoLabel0, self.memberInfoLabel1, self.memberInfoLabel2]
        
        for var i=0; i<3; ++i {
            var member: PFUser = self.groupMembers[i]
            var memberAge = member[parseConstants.KEY_AGE]! as String
            var memberHometown = member[parseConstants.KEY_HOMETOWN]! as String
            var memberInfoText = memberAge + "  : :  " + memberHometown
            
            var firstName = member[parseConstants.KEY_FIRST_NAME] as? String
            memberNames[i].text = firstName
            names[i] = firstName!
            memberInfo[i].text = memberInfoText
        }
    }
    
    // MARK: - Helper functions
    
    func styleReportButton() {
        self.reportButton.backgroundColor = UIColor.clearColor()
        self.reportButton.layer.cornerRadius = 5
        self.reportButton.layer.borderWidth = 1
        self.reportButton.layer.borderColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0).CGColor
        self.reportButton.tintColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0)
    }
    
    func reportGroupMember(i: Int) {
        self.currentUser.addObject(self.groupMembers[i].objectId, forKey: parseConstants.KEY_REPORTED)
        self.currentUser.saveInBackgroundWithBlock { (succeeded, error) -> Void in
        }
    }
    
    // MARK: - Actions
    
    @IBAction func showReportAbuse() {
        let reportController = UIAlertController(title: "Report abuse?", message: "If a user makes you feel at all uncomfortable, please report them. They will be flagged and reviewed.", preferredStyle: .ActionSheet)
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        reportController.addAction(cancelButton)
        
        let reportButton1 = UIAlertAction(title: "Report " + names[0], style: .Destructive, handler: { (action) -> Void in
            self.reportGroupMember(0)
        })
        reportController.addAction(reportButton1)
        
        let reportButton2 = UIAlertAction(title: "Report " + names[1], style: .Destructive, handler: { (action) -> Void in
            self.reportGroupMember(1)
        })
        reportController.addAction(reportButton2)
        
        let reportButton3 = UIAlertAction(title: "Report " + names[2], style: .Destructive, handler: { (action) -> Void in
            self.reportGroupMember(2)
        })
        reportController.addAction(reportButton3)
        
        self.presentViewController(reportController, animated: true, completion: nil)
    }
    
}