//
//  LoginTutorialViewController.swift
//  hello
//
//  Created by scott on 1/29/15.
//  Copyright (c) 2015 spw. All rights reserved.
//


import UIKit

class LoginViewController: UIViewController, UIPageViewControllerDataSource {
    
    @IBOutlet weak var tutorialLabel: UILabel!
    @IBOutlet weak var tutorialImageView: UIImageView!
    
    let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    let pageText = LoginTutorial().getText()
    let pageImages = LoginTutorial().getImages()
    var views: [LoginPageContentViewController] = []
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for var i=0; i<self.presentationCountForPageViewController(pageViewController); ++i {
            self.views.append(viewControllerAtIndex(i)!)
        }
        
        self.pageViewController.dataSource = self
    
        let startingViewController : LoginPageContentViewController = self.viewControllerAtIndex(0)!
        let viewControllers: NSArray = [startingViewController]
        self.pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        
        // Change the size of page view controller
        self.pageViewController.view.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 100);
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.darkGrayColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as LoginPageContentViewController).pageIndex
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index--
        
        return self.views[index]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as LoginPageContentViewController).pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        if index == self.pageText.count {
            return nil
        }
        
        return self.views[index];
        
    }
    
    func viewControllerAtIndex(index : Int) -> LoginPageContentViewController? {
        if self.pageText.count == 0 || index >= self.pageText.count {
            return nil;
        }
        
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginPageContentViewController") as LoginPageContentViewController
        pageContentViewController.image = self.pageImages[index]
        pageContentViewController.text = self.pageText[index]
        pageContentViewController.pageIndex = index
        
        return pageContentViewController;
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageText.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}