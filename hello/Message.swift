//
//  Message.swift
//  hello
//
//  Created by scott on 2/7/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import Foundation

class Message : NSObject, JSQMessageData {
    var _text: String
    var _sender: String
    var _time: String
    var _date: NSDate
    
    init(text: String?, sender: String?, time: String?) {
        self._text = text!
        self._sender = sender!
        self._time = time!
        self._date = NSDate()
    }
    
    func text() -> String! {
        return _text;
    }
    
    func sender() -> String! {
        return _sender;
    }
    
    func time() -> String! {
        return _time;
    }
    
    func date() -> NSDate! {
        return _date;
    }
    
}