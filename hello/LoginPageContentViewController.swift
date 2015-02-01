//
//  LoginTutorialViewController.swift
//  hello
//
//  Created by scott on 1/28/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit

class LoginPageContentViewController: UIViewController {
    
    @IBOutlet weak var tutorialLabel: UILabel!
    @IBOutlet weak var tutorialImageView: UIImageView!
    
    var pageIndex: Int
    var text: String
    var image: String

    required init(coder aDecoder: NSCoder) {
        pageIndex = 0
        text = LoginTutorial().getText()[0]
        image = LoginTutorial().getImages()[0]
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tutorialLabel.text = text
        tutorialImageView.image = UIImage(named: image)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}