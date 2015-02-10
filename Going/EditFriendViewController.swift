//
//  EditFriendViewController.swift
//  Going
//
//  Created by scott on 2/9/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit

class EditFriendViewController: UITableViewController {
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendInfoLabel: UILabel!
    @IBOutlet weak var friendProfileView: UIView!

    let actions: [String] = ["",
        "Delete",
        "Report",
        ""]
    let parseConstants: ParseConstants = ParseConstants()
    let currentUser: PFUser = PFUser.currentUser()
    var friendsRelation: PFRelation?
    var friend: PFUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.friendsRelation = self.currentUser.relationForKey(parseConstants.KEY_FRIENDS_RELATION)
        
        self.view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        self.friendProfileView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 18)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()]

        let friendName = friend[parseConstants.KEY_FIRST_NAME] as String
        let friendAge = friend[parseConstants.KEY_AGE] as String
        let friendHometown = friend[parseConstants.KEY_HOMETOWN] as String
        
        self.friendNameLabel.text = friendName
        self.friendInfoLabel.text = friendAge + "  : :  " + friendHometown
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.actions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        cell.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        
        cell.textLabel?.text = self.actions[indexPath.row]
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0 || indexPath.row == 3) {
            return 0.5
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
            // Delete
        case 1:
            let deleteController = UIAlertController(title: "Delete friend?", message: "This friend will be removed from your friend list and you will be unable to chat again. Are you sure?", preferredStyle: .Alert)
            let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            deleteController.addAction(cancelButton)
            let deleteButton = UIAlertAction(title: "Delete", style: .Default, handler: { (action) -> Void in
                self.deleteFriend()
            })
            deleteController.addAction(deleteButton)
            
            self.presentViewController(deleteController, animated: true, completion: nil)
            break
            // Report
        case 2:
            let reportController = UIAlertController(title: "Report?", message: "If a user makes you feel at all uncomfortable, please report them. They will be flagged, removed from your friends list and prevented from contacting you again.", preferredStyle: .Alert)
            let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            reportController.addAction(cancelButton)
            let reportButton = UIAlertAction(title: "Report", style: .Destructive, handler: { (action) -> Void in
                self.reportFriend()
            })
            reportController.addAction(reportButton)
            
            self.presentViewController(reportController, animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    func deleteFriend() {
        self.friendsRelation?.removeObject(self.friend)
        self.currentUser.saveInBackgroundWithBlock { (succeeded, error) -> Void in
        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    func reportFriend() {
        self.currentUser.addObject(self.friend.objectId, forKey: parseConstants.KEY_REPORTED)
        self.deleteFriend()
    }
    
}