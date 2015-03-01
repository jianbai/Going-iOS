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
        "Free this weekend?",
        "Match up",
        "Meet up",
        "Make friends"
    ]
    
    let imageArray = [
        "Home",
        "MatchMade",
        "GroupChat",
        "MatchExpired"
    ]
    
    func getText() -> [String] {
        return self.textArray
    }
    
    func getImages() -> [String] {
        return self.imageArray
    }
    
}