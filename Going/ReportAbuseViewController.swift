//
//  ReportAbuseViewController.swift
//  Going
//
//  Created by scott on 2/26/15.
//  Copyright (c) 2015 spw. All rights reserved.
//


import UIKit

class ReportAbuseViewController: UITableViewController {
    @IBOutlet weak var reportButton: UIButton!
    
    let parseConstants: ParseConstants = ParseConstants()
    
    var currentUser: PFUser!
    var groupMembersRelation: PFRelation!
    var friendsRelation: PFRelation!
    var groupMembers: [PFUser] = []
    var isChecked: [Bool] = [true, true, true]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        self.currentUser = PFUser.currentUser()
        
        self.styleReportButton()
        
        self.groupMembersRelation = self.currentUser.relationForKey(self.parseConstants.KEY_GROUP_MEMBERS_RELATION)
        self.friendsRelation = self.currentUser.relationForKey(self.parseConstants.KEY_FRIENDS_RELATION)
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
    
    // MARK: - Helper Functions
    
    func styleReportButton() {
        self.reportButton.backgroundColor = UIColor.clearColor()
        self.reportButton.layer.cornerRadius = 5
        self.reportButton.layer.borderWidth = 1
        self.reportButton.layer.borderColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0).CGColor
        self.reportButton.tintColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0)
    }
    
    func reportGroupMember() {
        for var i=0; i<3; ++i {
            if self.isChecked[i] {
                self.currentUser.addObject(self.groupMembers[i].objectId, forKey: parseConstants.KEY_REPORTED)
            }
        }
        self.currentUser.saveInBackgroundWithBlock { (succeeded, error) -> Void in
        }
    }
    
    // MARK: - Actions
    
    @IBAction func reportAbuse() {
        let reportController = UIAlertController(title: "Report abuse?", message: "If a user makes you feel at all uncomfortable, please report them. They will be flagged and reviewed.", preferredStyle: .Alert)
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        reportController.addAction(cancelButton)
        let reportButton = UIAlertAction(title: "Report", style: .Destructive, handler: { (action) -> Void in
            self.reportGroupMember()
        })
        reportController.addAction(reportButton)
        
        self.presentViewController(reportController, animated: true, completion: nil)
    }
}