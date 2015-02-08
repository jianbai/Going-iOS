//
//  GroupChatViewController.swift
//  hello
//
//  Created by scott on 2/5/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit
import Foundation


import UIKit
import Foundation

class GroupChatViewController: JSQMessagesViewController {
    
    //    var groupChatRef: Firebase!

    let parseConstants: ParseConstants = ParseConstants()
    let firebaseConstants: FirebaseConstants = FirebaseConstants()
    var currentUser: PFUser!
    var messages = [Message]()
    var outgoingBubbleImageView = JSQMessagesBubbleImageFactory.outgoingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    var incomingBubbleImageView = JSQMessagesBubbleImageFactory.incomingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleGreenColor())
    var batchMessages = true

    // *** STEP 1: STORE FIREBASE REFERENCES
    var groupChatRef: Firebase!
    
    func setupFirebase() {
        // *** STEP 2: SETUP FIREBASE
        var query = PFQuery(className: self.parseConstants.CLASS_GROUPS)
        query.whereKey(self.parseConstants.KEY_GROUP_MEMBER_IDS, equalTo: self.currentUser.objectId)
        query.getFirstObjectInBackgroundWithBlock { (group, error) -> Void in
            self.groupChatRef = Firebase(url: self.firebaseConstants.URL_GROUP_CHATS).childByAppendingPath(group.objectId)
            // *** STEP 4: RECEIVE MESSAGES FROM FIREBASE
            self.groupChatRef.observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
                let text = snapshot.value["message"] as? String
                let sender = snapshot.value["author"] as? String
                let time = snapshot.value["time"] as? String
                
                let message = Message(text: text, sender: sender, time: time)
                self.messages.append(message)
                self.finishReceivingMessage()
            })
        }
        

    }
    
    func sendMessage(text: String!, sender: String!, time: String!) {
        // *** STEP 3: ADD A MESSAGE TO FIREBASE
        self.groupChatRef.childByAutoId().setValue([
            "message":text,
            "author":sender,
            "time":time
            ])
    }
    
    func tempSendMessage(text: String!, sender: String!, time: String!) {
        let message = Message(text: text, sender: sender, time: time)
        messages.append(message)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentUser = PFUser.currentUser()

        self.navigationItem.hidesBackButton = true
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero

        
        inputToolbar.contentView.leftBarButtonItem = nil
        automaticallyScrollsToMostRecentMessage = true
        
        sender = self.currentUser[parseConstants.KEY_FIRST_NAME] as String
 
        setupFirebase()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.collectionViewLayout.springinessEnabled = true
    }
    
    // ACTIONS
    
    func receivedMessagePressed(sender: UIBarButtonItem) {
        // Simulate reciving message
        showTypingIndicator = !showTypingIndicator
        scrollToBottomAnimated(true)
    }
    
    func getTimeStamp(date: NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h'.'mm a"
        
        return dateFormatter.stringFromDate(date)
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, sender: String!, date: NSDate!) {
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        var time = self.getTimeStamp(date)
        
        sendMessage(text, sender: sender, time: time)
        
        finishSendingMessage()
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, bubbleImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        let message = messages[indexPath.item]
        
        if message.sender() == sender {
            return UIImageView(image: outgoingBubbleImageView.image, highlightedImage: outgoingBubbleImageView.highlightedImage)
        }
        
        return UIImageView(image: incomingBubbleImageView.image, highlightedImage: incomingBubbleImageView.highlightedImage)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        return nil
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        if message.sender() == sender {
            cell.textView.textColor = UIColor.blackColor()
        } else {
            cell.textView.textColor = UIColor.whiteColor()
        }
        
        let attributes : [NSObject:AnyObject] = [NSForegroundColorAttributeName:cell.textView.textColor, NSUnderlineStyleAttributeName: 1]
        cell.textView.linkTextAttributes = attributes
        
        return cell
    }
    
    
    // View  usernames above bubbles
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item];
        
        // Sent by me, skip
        if message.sender() == sender {
            return nil;
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.sender() == message.sender() {
                return nil;
            }
        }
        
        return NSAttributedString(string:message.sender())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        
        // Sent by me, skip
        if message.sender() == sender {
            return CGFloat(0.0);
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.sender() == message.sender() {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
}