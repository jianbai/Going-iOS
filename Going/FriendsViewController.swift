//
//  SecondViewController.swift
//  Going
//
//  Created by scott on 1/27/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit

class FriendsViewController: UITableViewController {
    @IBOutlet weak var emptyView: UIView!

    let currentUser = PFUser.currentUser()
    let parseConstants: ParseConstants = ParseConstants()
    var friendsRelation: PFRelation!
    var friends: [PFUser] = []
    var chatId: String?
    var friend: PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.friendsRelation = self.currentUser.relationForKey(parseConstants.KEY_FRIENDS_RELATION)
        
        self.view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 18)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadFriends()
    }
    
    func loadFriends() {
        var query = self.friendsRelation.query()
        query.orderByAscending(self.parseConstants.KEY_FIRST_NAME)
        query.findObjectsInBackgroundWithBlock { (friends, error) -> Void in
            self.friends = friends as [PFUser]
            self.emptyView.hidden = self.friends.count != 0
            
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifer = "Cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifer, forIndexPath: indexPath) as UITableViewCell
        
        cell.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        
        cell.textLabel?.text = self.friends[indexPath.row][self.parseConstants.KEY_FIRST_NAME] as? String
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        
        cell.hidden = self.friends.count == 0
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Deselect cell
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        // Get tapped cell
        var cell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        
        self.friend = self.friends[indexPath.row]
        
        var currentUserObjectId = self.currentUser.objectId
        var friendObjectId = friend!.objectId
        var currentUserFacebookId = (self.currentUser[self.parseConstants.KEY_FACEBOOK_ID] as NSString).doubleValue
        var friendFacebookId = (friend![self.parseConstants.KEY_FACEBOOK_ID] as NSString).doubleValue
        
        if (currentUserFacebookId < friendFacebookId) {
            self.chatId = currentUserObjectId + friendObjectId
        } else {
            self.chatId = friendObjectId + currentUserObjectId
        }
        
        performSegueWithIdentifier("showFriendChat", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showFriendChat") {
            var friendChatViewController = segue.destinationViewController as FriendChatViewController
            
            friendChatViewController.chatId = self.chatId
            friendChatViewController.friend = self.friend
            
            self.definesPresentationContext = true
            friendChatViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        }
    }
    
    @IBAction func meetThisWeekend() {
        self.tabBarController?.selectedIndex = 1
    }
}

