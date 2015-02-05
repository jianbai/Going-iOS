//
//  SetProfile.swift
//  hello
//
//  Created by scott on 1/28/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit

class SetProfileViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var hometownTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var saveProfileButton: UIButton!
    @IBOutlet weak var saveProfileActivityIndicator: UIActivityIndicatorView!

    let parseConstants: ParseConstants = ParseConstants()
    let pickerData: [String] = ["Female", "Male"]
    let currentUser: PFUser = PFUser.currentUser()

    var noGender: Bool!
    var noAge: Bool!
    var noHometown: Bool!
//    var loginViewController: UIViewController!
    
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
        self.saveProfileActivityIndicator.hidden = true
        
        self.birthdayTextField.returnKeyType = UIReturnKeyType.Done
        self.hometownTextField.returnKeyType = UIReturnKeyType.Done
        self.genderTextField.returnKeyType = UIReturnKeyType.Done
        self.birthdayTextField.delegate = self
        self.hometownTextField.delegate = self
        self.genderTextField.delegate = self

//        self.loginViewController = self.presentingViewController
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == birthdayTextField) {
            let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 240))

            var datePicker: UIDatePicker = UIDatePicker(frame: CGRectMake(0, 0, 0, 0))
            datePicker.datePickerMode = UIDatePickerMode.Date
            inputView.addSubview(datePicker)
            var doneButton = UIButton(frame: CGRectMake((self.view.frame.size.width/2) - (100/2), 200, 100, 40))
            doneButton.setTitle("Done", forState: UIControlState.Normal)
            doneButton.setTitle("Done", forState: UIControlState.Highlighted)
            doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
            inputView.addSubview(doneButton)
            
            datePicker.addTarget(self, action: Selector("updateBirthdayTextField:"), forControlEvents: UIControlEvents.ValueChanged)
            doneButton.addTarget(self, action: Selector("resignDatePicker:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            textField.inputView = inputView
        } else if (textField == genderTextField) {
            let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 240))

            var genderPicker: UIPickerView = UIPickerView(frame: CGRectMake(0, 0, self.view.frame.width, 200))
            genderPicker.delegate = self
            genderPicker.dataSource = self
            inputView.addSubview(genderPicker)
            
            var doneButton = UIButton(frame: CGRectMake((self.view.frame.size.width/2) - (100/2), 200, 100, 40))
            doneButton.setTitle("Done", forState: UIControlState.Normal)
            doneButton.setTitle("Done", forState: UIControlState.Highlighted)
            doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
            inputView.addSubview(doneButton)
            
            doneButton.addTarget(self, action: Selector("resignGenderPicker:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            textField.inputView = inputView
        }
        
        animateTextField(textField, up: true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateGenderTextField(row)
    }
    
    func updateBirthdayTextField(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        birthdayTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func updateGenderTextField(row: Int) {
        genderTextField.text = pickerData[row]
    }
    
    func resignDatePicker(sender: UIButton) {
        birthdayTextField.resignFirstResponder()
    }
    
    func resignGenderPicker(sender: UIButton) {
        genderTextField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        animateTextField(textField, up: false)
    }
    
    func animateTextField(textField: UITextField, up: Bool) {
        
        instructionsLabel.hidden = up
        var movementDistance: CGFloat = 120
        let movementDuration = 0.3
        
        if (self.noAge as Bool &&
            self.birthdayTextField != textField) {
            birthdayTextField.hidden = up
        }
        if (self.noHometown as Bool &&
            hometownTextField != textField) {
            hometownTextField.hidden = up
        }
        if (self.noGender as Bool &&
            genderTextField != textField) {
            genderTextField.hidden = up
        }
        
        var movement: CGFloat = (up ? -movementDistance : movementDistance)
        
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        
        UIView.commitAnimations()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setBools(noGender: Bool, noAge: Bool, noHometown: Bool) {
        self.noGender = noGender
        self.noAge = noAge
        self.noHometown = noHometown
    }
    
    func calculateAge(birthday : String) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        var date = dateFormatter.dateFromString(birthday)
        var cal = NSCalendar.currentCalendar()
        
        var age = String(cal.components(NSCalendarUnit.CalendarUnitYear, fromDate: date!, toDate: NSDate(), options: nil).year)
        
        return age
    }
    
    func updateAge() {
        var birthday: String = birthdayTextField.text
        var age: String = self.calculateAge(birthday)
        self.currentUser[parseConstants.KEY_BIRTHDAY] = birthday
        self.currentUser[parseConstants.KEY_AGE] = age
    }
    
    func updateHometown() {
        var hometown: String = hometownTextField.text
        self.currentUser[parseConstants.KEY_HOMETOWN] = hometown
    }
    
    func updateGender() {
        var gender: String = genderTextField.text
        self.currentUser[parseConstants.KEY_GENDER] = gender
    }
    
    func saveToParse() {
        self.currentUser.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
            if (error == nil) {
                let loginViewController: UIViewController = self.presentingViewController!
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    loginViewController.performSegueWithIdentifier("showMain", sender: loginViewController)
                })
            } else {
                self.showErrorAlert()
            }
            self.hideActivityIndicator()
        }
    }
    
    func showActivityIndicator() {
        self.saveProfileButton.hidden = true
        self.saveProfileActivityIndicator.hidden = false
        self.saveProfileActivityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        self.saveProfileButton.hidden = false
        self.saveProfileActivityIndicator.hidden = true
        self.saveProfileActivityIndicator.stopAnimating()
    }
    
    func showErrorAlert() {
        let saveProfileErrorController = UIAlertController(title: "Uh oh...", message: "Something is rotten in the state of your network connection...", preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
        saveProfileErrorController.addAction(okButton)
        
        self.presentViewController(saveProfileErrorController, animated: true, completion: nil)
    }

    func showIncompleteAlert() {
        let saveProfileErrorController = UIAlertController(title: "Uh oh...", message: "One of your required fields is missing! Please set up your profile before continuing.", preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
        saveProfileErrorController.addAction(okButton)
        
        self.presentViewController(saveProfileErrorController, animated: true, completion: nil)
    }
    
    func showInvalidAgeAlert() {
        let saveProfileErrorController = UIAlertController(title: "Uh oh...", message: "You have entered an invalid birthday.", preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
        saveProfileErrorController.addAction(okButton)

        self.presentViewController(saveProfileErrorController, animated: true, completion: nil)
    }
    
    @IBAction func saveProfile() {
        self.showActivityIndicator()
        
        let emptyBirthday = self.noAge as Bool &&
            self.birthdayTextField.text.isEmpty
        let emptyHometown = self.noHometown as Bool &&
            self.hometownTextField.text.isEmpty
        let emptyGender = self.noGender as Bool &&
            self.genderTextField.text.isEmpty
        
        if (emptyBirthday || emptyHometown || emptyGender) {
            self.showIncompleteAlert()
            self.hideActivityIndicator()
        } else if (self.calculateAge(birthdayTextField.text).toInt() < 16) {
            self.showInvalidAgeAlert()
            self.hideActivityIndicator()
        } else {
            if (self.noAge as Bool) {
                self.updateAge()
            }
            if (self.noHometown as Bool) {
                self.updateHometown()
            }
            if (self.noGender as Bool) {
                self.updateGender()
            }
            
            self.saveToParse()
        }
    }
}