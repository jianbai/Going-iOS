//
//  SetAgeTextFieldDelegate.swift
//  hello
//
//  Created by scott on 2/1/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import Foundation

class SetAgeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    
    let movementDistance: CGFloat = 80
    let movementDuration = 0.3
    var viewController: SetProfileViewController
    
    init(viewController: SetProfileViewController) {
        self.viewController = viewController
    }
    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        animateTextField(textField, up: true)
//    }
//    
//    func textFieldDidEndEditing(textField: UITextField) {
//        animateTextField(textField, up: false)
//    }
//    
//    func animateTextField(textField: UITextField, up: Bool) {
//        
//        var movement: CGFloat = (up ? -movementDistance : movementDistance)
//        
//        UIView.beginAnimations("anim", context: nil)
//        UIView.setAnimationBeginsFromCurrentState(true)
//        UIView.setAnimationDuration(movementDuration)
//        viewController.view.frame = CGRectOffset(viewController.view.frame, 0, movement)
//        
//        UIView.commitAnimations()
//    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
        viewController.view.endEditing(true)
        return false
    }
    

}