//
//  ContactViewController.swift
//  Going
//
//  Created by scott on 2/4/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    let currentUser: PFUser = PFUser.currentUser()
    let parseConstants: ParseConstants = ParseConstants()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        
        self.styleSendButton()
        self.styleNavigationBar()
        
        self.contactTextField.returnKeyType = UIReturnKeyType.Done
        self.contactTextField.delegate = self
        self.contactTextField.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
    }
    
    // MARK: - TextField Delegate
    
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
    
    // MARK: - Helper Functions
    
    func styleSendButton() {
        self.sendButton.backgroundColor = UIColor.clearColor()
        self.sendButton.layer.cornerRadius = 5
        self.sendButton.layer.borderWidth = 1
        self.sendButton.layer.borderColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0).CGColor
        self.sendButton.tintColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0)
    }
    
    func styleNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.99, green: 0.66, blue: 0.26, alpha: 1.0)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 18)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()]
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
    
    // MARK: - Actions
    
    @IBAction func send() {
        var contactText = self.contactTextField.text
        self.currentUser.addObject(contactText, forKey: parseConstants.KEY_CONTACT_US)
        self.currentUser.saveInBackgroundWithBlock { (succeeded, error) -> Void in
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
}
