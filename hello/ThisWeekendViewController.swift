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
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 18)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        var isMatched = self.currentUser[parseConstants.KEY_IS_MATCHED] as Bool
        
        if (isMatched) {
            performSegueWithIdentifier("showGroupChat", sender: self)
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
        
        NSLog("DISAPPEAR OBSERVERS")
        self.ref.removeAllObservers()
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
        self.currentUser.save()
        
        self.performSegueWithIdentifier("showGroupChat", sender: self)
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
            self.currentUser.save()
            NSLog("GOGOGO")
        }
    }
    
    @IBAction func showHelp() {
        self.performSegueWithIdentifier("showHelp", sender: self)
    }
    
}