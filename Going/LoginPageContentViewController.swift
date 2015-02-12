//
//  LoginPageContentViewController.swift
//  Going
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
        self.pageIndex = 0
        self.text = LoginTutorial().getText()[0]
        self.image = LoginTutorial().getImages()[0]
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tutorialLabel.text = text
        self.tutorialImageView.image = UIImage(named: image)
    }
    
}