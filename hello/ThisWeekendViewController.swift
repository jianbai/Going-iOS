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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.goActivityIndicator.hidden = true
        self.view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 18)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.showActivityIndicator()
    }
    
    @IBAction func showHelp() {
        self.performSegueWithIdentifier("showHelp", sender: self)
    }
    
}