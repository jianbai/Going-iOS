//
//  SetProfile.swift
//  hello
//
//  Created by scott on 1/28/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit

class SetProfileViewController: UIViewController {
    
    var noGender: Bool!
    var noAge: Bool!
    var noHometown: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBools(noGender: Bool, noAge: Bool, noHometown: Bool) {
        self.noGender = noGender
        self.noAge = noAge
        self.noHometown = noHometown
    }
    
}