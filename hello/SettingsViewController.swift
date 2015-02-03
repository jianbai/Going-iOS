//
//  FirstViewController.swift
//  hello
//
//  Created by scott on 1/27/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    let settings: [String] = ["Age preferences",
        "Gender preferences",
        "FAQ",
        "RAQ",
        "Gahh I found a bug!",
        "Dear Go:",
        "Log out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = self.settings[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        // Age preferences
        case 0:
            self.showAgePreferencesAlert()
            break
        // Gender preferences
        case 1:
            self.showGenderPreferencesAlert()
            break
        // FAQ
        case 2:
            self.showFaqAlert()
            break
        // RAQ
        case 3:
            self.showRaqAlert()
            break
        // Report a bug
        case 4:
            self.showBugAlert()
            break
        // Get in touch
        case 5:
            self.showContactAlert()
            break
        // Logout
        case 6:
            self.logOut()
            break
        default:
            break
        }
    }
    
// MARK: - Table cell click handlers
    
    func showAgePreferencesAlert() {
        
    }
    
    func showGenderPreferencesAlert() {
        
    }
    
    func showFaqAlert() {
        
    }
    
    func showRaqAlert() {
        
    }
    
    func showBugAlert() {
        
    }
    
    func showContactAlert() {
        
    }
    
    func logOut() {
        
    }
    
}

