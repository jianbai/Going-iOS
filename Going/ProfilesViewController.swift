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
    
    let parseConstants: ParseConstants = ParseConstants()
    
    var groupMembers: [PFUser] = []

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
}