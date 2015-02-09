//
//  RaqViewController.swift
//  hello
//
//  Created by scott on 2/4/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit

class RaqViewController: UIViewController {
    @IBOutlet weak var raqView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        self.raqView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 18)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()]
    }

}