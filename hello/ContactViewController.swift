//
//  ContactViewController.swift
//  hello
//
//  Created by scott on 2/4/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var contactTextField: UITextField!
    let currentUser: PFUser = PFUser.currentUser()
    let parseConstants: ParseConstants = ParseConstants()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contactTextField.returnKeyType = UIReturnKeyType.Done
        self.contactTextField.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.animateTextField(textField, up: true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.animateTextField(textField, up: false)
    }
    
    func animateTextField(textField: UITextField, up: Bool) {
        
        self.contactLabel.hidden = up
        var movementDistance: CGFloat = 80
        let movementDuration = 0.3
        
        var movement: CGFloat = (up ? -movementDistance : movementDistance)
        
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        
        UIView.commitAnimations()
    }
    
    @IBAction func cancelContact(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sendContact(sender: UIBarButtonItem) {
        var contactText = self.contactTextField.text
        self.currentUser.addObject(contactText, forKey: parseConstants.KEY_CONTACT_US)
        self.currentUser.save()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
