//
//  ReplaceSegue.swift
//  Going
//
//  Created by scott on 2/7/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

class ReplaceSegue: UIStoryboardSegue {
    override func perform() {
        let source = self.sourceViewController as UIViewController
        let destination = self.destinationViewController as UIViewController
        let nav = source.navigationController! as UINavigationController
        
        var stack = nav.viewControllers as [UIViewController]
        if let index = find(stack, source) {
            stack[index] = destination
        }
        nav.viewControllers = stack
    }
}