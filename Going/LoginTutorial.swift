//
//  LoginTutorial.swift
//  Going
//
//  Created by scott on 1/29/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import Foundation

struct LoginTutorial {
    
    let textArray = [
        "Free this weekend?\nMatch up with 3 people around you, chat in the app and make plans to go somewhere cool!",
        "Matches disappear at the end of every weekend. You can choose to keep matches you liked in your friends list.",
        "Go again next weekend to meet more people and grow your friends list!"
    ]
    
    let imageArray = [
        "LoginTutorial0",
        "LoginTutorial1",
        "LoginTutorial2"
    ]
    
    func getText() -> [String] {
        return self.textArray
    }
    
    func getImages() -> [String] {
        return self.imageArray
    }
    
}