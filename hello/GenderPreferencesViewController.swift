//
//  GenderPreferencesViewController.swift
//  hello
//
//  Created by scott on 2/3/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import Foundation

import UIKit

class GenderPreferencesViewController: UITableViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var genderPreferencesActivityIndicator: UIActivityIndicatorView!
    
    let genderPreferences: [String] = ["I don't discriminate!",
        "Coed (2 and 2)",
        "Single sex",
        ""]
    let parseConstants: ParseConstants = ParseConstants()
    let currentUser: PFUser = PFUser.currentUser()
    var gender: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideActivityIndicator()
        self.gender = self.getGenderPreference()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 18)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.genderPreferences.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifer = "Cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifer, forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = self.genderPreferences[indexPath.row]
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        
        if (indexPath.row == self.getGenderPreference()) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Deselect cell
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        // Get tapped cell
        var cell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        
        self.gender = indexPath.row
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        for row in 0...3 {
            if (row != indexPath.row) {
                var c = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0))! as UITableViewCell
                c.accessoryType = UITableViewCellAccessoryType.None
            }
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
    
    func getGenderPreference() -> Int {
        return self.currentUser[parseConstants.KEY_GENDER_SETTINGS] as Int
    }
    
    func hideActivityIndicator() {
        self.genderPreferencesActivityIndicator.hidden = true
        self.genderPreferencesActivityIndicator.stopAnimating()
        self.saveButton.hidden = false
    }
    
    func showActivityIndicator() {
        self.saveButton.hidden = true
        self.genderPreferencesActivityIndicator.hidden = false
        self.genderPreferencesActivityIndicator.startAnimating()
    }
    
    @IBAction func saveSettings() {
        self.showActivityIndicator()
        
        self.currentUser[parseConstants.KEY_GENDER_SETTINGS] = self.gender
        
        self.currentUser.save()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}