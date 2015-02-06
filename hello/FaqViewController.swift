//
//  FaqViewController.swift
//  hello
//
//  Created by scott on 2/3/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit

class FaqViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 18)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    @IBAction func exitFaq(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
