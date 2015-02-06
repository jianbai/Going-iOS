//
//  AgePreferencesViewController.swift
//  hello
//
//  Created by scott on 2/3/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit

class AgePreferencesViewController: UITableViewController {
    
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var agePreferencesActivityIndicator: UIActivityIndicatorView!
    
    let agePreferences: [String] = ["Ageism is lame!",
        "20's",
        "30's",
        "40's",
        ""]
    let parseConstants: ParseConstants = ParseConstants()
    let currentUser: PFUser = PFUser.currentUser()
    var isChecked: [Bool] = [false,
        false,
        false,
        false,
        false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideActivityIndicator()
        
        self.view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        self.saveView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
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
        return self.agePreferences.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifer = "Cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifer, forIndexPath: indexPath) as UITableViewCell
        
        cell.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        
        cell.textLabel?.text = self.agePreferences[indexPath.row]
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        
        if (self.isPreferenceChecked(indexPath.row)) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        self.isChecked[indexPath.row] = self.isPreferenceChecked(indexPath.row)
        
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
            
            var noneChecked: Bool = true
            for row in 0...3 {
                var c = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0))! as UITableViewCell
                if (self.isChecked[row]) {
                    noneChecked = false
                }
            }
            
            if (noneChecked) {
                var c = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))! as UITableViewCell
                c.accessoryType = UITableViewCellAccessoryType.Checkmark
                self.isChecked[0] = true
            }
        } else {
            if (indexPath.row == 0) {
                for row in 1...3 {
                    var c = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0))! as UITableViewCell
                    c.accessoryType = UITableViewCellAccessoryType.None
                    self.isChecked[row] = false
                }
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                self.isChecked[0] = true
            } else {
                var c = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))! as UITableViewCell
                c.accessoryType = UITableViewCellAccessoryType.None
                self.isChecked[0] = false
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                self.isChecked[indexPath.row] = true
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 4) {
            return 0.01
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    func isPreferenceChecked(row: Int) -> Bool {
        var checked: Bool
        
        switch (row) {
        case 0:
            checked = self.currentUser[parseConstants.KEY_AGE_SETTINGS_0] as Bool
            break
        case 1:
            checked = self.currentUser[parseConstants.KEY_AGE_SETTINGS_20] as Bool
            break
        case 2:
            checked = self.currentUser[parseConstants.KEY_AGE_SETTINGS_30] as Bool
            break
        case 3:
            checked = self.currentUser[parseConstants.KEY_AGE_SETTINGS_40] as Bool
            break
        default:
            checked = false
            break
        }
        
        return checked
    }
    
    func hideActivityIndicator() {
        self.agePreferencesActivityIndicator.hidden = true
        self.agePreferencesActivityIndicator.stopAnimating()
        self.saveButton.hidden = false
    }
    
    func showActivityIndicator() {
        self.saveButton.hidden = true
        self.agePreferencesActivityIndicator.hidden = false
        self.agePreferencesActivityIndicator.startAnimating()
    }
    
    @IBAction func saveSettings() {
        self.showActivityIndicator()
        
        for row in 0...3 {
            var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0))! as UITableViewCell
            
            switch (row) {
            case 0:
                self.currentUser[parseConstants.KEY_AGE_SETTINGS_0] = cell.accessoryType == UITableViewCellAccessoryType.Checkmark
                break
            case 1:
                self.currentUser[parseConstants.KEY_AGE_SETTINGS_20] = cell.accessoryType == UITableViewCellAccessoryType.Checkmark
                break
            case 2:
                self.currentUser[parseConstants.KEY_AGE_SETTINGS_30] = cell.accessoryType == UITableViewCellAccessoryType.Checkmark
                break
            case 3:
                self.currentUser[parseConstants.KEY_AGE_SETTINGS_40] = cell.accessoryType == UITableViewCellAccessoryType.Checkmark
                break
            default:
                break
            }
        }
        
        self.currentUser.save()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}