//
//  RaqViewController.swift
//  hello
//
//  Created by scott on 2/4/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit

class RaqViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 18)!]
    }
    
    @IBAction func exitRaq(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}