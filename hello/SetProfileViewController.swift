//
//  SetProfile.swift
//  hello
//
//  Created by scott on 1/28/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit

class SetProfileViewController: UIViewController {
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var hometownTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
  
    var noGender: Bool! = true
    var noAge: Bool! = true
    var noHometown: Bool! = false
    var gender: String?
    var age: String?
    var hometown: String?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (!self.noAge) {
            self.birthdayTextField.hidden = true
        }
        if (!self.noHometown) {
            self.hometownTextField.hidden = true
        }
        if (!self.noGender) {
            self.genderTextField.hidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.birthdayTextField.returnKeyType = UIReturnKeyType.Done
//        self.birthdayTextField.delegate = self
//        self.hometownTextField.delegate = self
//        self.genderTextField.delegate = self
        self.hometownTextField.returnKeyType = UIReturnKeyType.Done
        self.genderTextField.returnKeyType = UIReturnKeyType.Done
        self.birthdayTextField.delegate = SetAgeTextFieldDelegate(viewController: self)
        self.hometownTextField.delegate = SetHometownTextFieldDelegate(viewController: self)
        self.genderTextField.delegate = SetGenderTextFieldDelegate(viewController: self)
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