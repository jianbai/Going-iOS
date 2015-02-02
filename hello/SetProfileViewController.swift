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
  
    let pickerData = ["Female", "Male"]
    
    var noGender: Bool! = true
    var noAge: Bool! = true
    var noHometown: Bool! = true
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
        self.hometownTextField.returnKeyType = UIReturnKeyType.Done
        self.genderTextField.returnKeyType = UIReturnKeyType.Done
        self.birthdayTextField.delegate = self
        self.hometownTextField.delegate = self
        self.genderTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
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
        } else if (textField == hometownTextField) {

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
        if (textField == hometownTextField) {

        }
        
        animateTextField(textField, up: false)
    }
    
    func animateTextField(textField: UITextField, up: Bool) {
        
        instructionsLabel.hidden = up
        var movementDistance: CGFloat = 120
        let movementDuration = 0.3
        
        if (birthdayTextField != textField) {
            birthdayTextField.hidden = up
        }
        if (hometownTextField != textField) {
            hometownTextField.hidden = up
        }
        if (genderTextField != textField) {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBools(noGender: Bool, noAge: Bool, noHometown: Bool) {
        self.noGender = noGender
        self.noAge = noAge
        self.noHometown = noHometown
    }
    
    @IBAction func saveProfile() {
        
    }
}