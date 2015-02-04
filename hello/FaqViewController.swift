//
//  FaqViewController.swift
//  hello
//
//  Created by scott on 2/3/15.
//  Copyright (c) 2015 spw. All rights reserved.
//

import UIKit

class FaqViewController: UIViewController {

    @IBOutlet weak var questionLabel0: UILabel!
    @IBOutlet weak var answerLabel0: UILabel!
    @IBOutlet weak var questionLabel1: UILabel!
    @IBOutlet weak var answerLabel1: UILabel!
    @IBOutlet weak var questionLabel2: UILabel!
    @IBOutlet weak var answerLabel2: UILabel!
    @IBOutlet weak var questionLabel3: UILabel!
    @IBOutlet weak var answerLabel3: UILabel!
    @IBOutlet weak var questionLabel4: UILabel!
    @IBOutlet weak var answerLabel4: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.setContentOffset(CGPointMake(0, self.scrollView.contentOffset.y), animated: true)
        self.scrollView.directionalLockEnabled = true
        self.adjustLabelSize(self.questionLabel0)
        self.adjustLabelSize(self.answerLabel0)
//        self.adjustLabelSize(answer1)
//        self.adjustLabelSize(answer2)
//        self.adjustLabelSize(answer3)
//        self.adjustLabelSize(answer4)
    }
    
    func adjustLabelSize(label: UILabel!) {
        let maxHeight: CGFloat = 10000
        let rect = label.attributedText.boundingRectWithSize(CGSizeMake(label.frame.size.width, maxHeight), options: .UsesLineFragmentOrigin, context: nil)
        var frame = label.frame
        frame.size.height = rect.size.height
        label.frame = frame
    }
    
    @IBAction func exitFaq(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
