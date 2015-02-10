//
//  MatchExpiredViewController.swift
//  Going
//
//  Created by scott on 2/7/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit

class MatchExpiredViewController: UITableViewController {
    @IBOutlet weak var addButton: UIButton!

    let parseConstants: ParseConstants = ParseConstants()
    let currentUser: PFUser = PFUser.currentUser()
    var groupMembersRelation: PFRelation!
    var friendsRelation: PFRelation!
    var groupMembers: [PFUser] = []
    var isChecked: [Bool] = [true, true, true]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        self.styleAddButton()
        
        self.groupMembersRelation = self.currentUser.relationForKey(self.parseConstants.KEY_GROUP_MEMBERS_RELATION)
        self.friendsRelation = self.currentUser.relationForKey(self.parseConstants.KEY_FRIENDS_RELATION)
    }
    
    func styleAddButton() {
        self.addButton.backgroundColor = UIColor.clearColor()
        self.addButton.layer.cornerRadius = 5
        self.addButton.layer.borderWidth = 1
        self.addButton.layer.borderColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0).CGColor
        self.addButton.tintColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupMembers.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifer = "Cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifer, forIndexPath: indexPath) as UITableViewCell
        
        cell.tintColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0)
        cell.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        
        cell.textLabel?.text = self.groupMembers[indexPath.row][parseConstants.KEY_FIRST_NAME] as? String
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Deselect cell
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        // Get tapped cell
        var cell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        
        if (self.isChecked[indexPath.row]) {
            cell.accessoryType = UITableViewCellAccessoryType.None
            self.isChecked[indexPath.row] = false
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            self.isChecked[indexPath.row] = true
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 3) {
            return 0.01
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }

    @IBAction func addFriends() {
        for var i=0; i<3; ++i {
            self.groupMembersRelation.removeObject(self.groupMembers[i])
            if self.isChecked[i] {
                self.friendsRelation.addObject(self.groupMembers[i])
            }
        }
        
        self.currentUser[parseConstants.KEY_PICK_FRIENDS_DIALOG_SEEN] = true
        self.currentUser[parseConstants.KEY_MATCH_DIALOG_SEEN] = false
        self.currentUser[parseConstants.KEY_IS_MATCHED] = false
        self.currentUser.saveInBackgroundWithBlock { (succeeded, error) -> Void in
        }
        
        if let installation = PFInstallation.currentInstallation() {
            installation.removeObjectForKey(parseConstants.KEY_INSTALLATION_GROUP_ID)
            installation.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
            })
        }
        
        let groupChatViewController = self.presentingViewController! as UIViewController
        groupChatViewController.title = "This Weekend"
        var item = groupChatViewController.tabBarController?.tabBar.items![1] as UITabBarItem
        item.title = nil
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            groupChatViewController.performSegueWithIdentifier("showThisWeekend", sender: groupChatViewController)
        })
    }
}