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
    
    var pageViewController: UIPageViewController?
    let pageTitles = ["1", "2", "3", "4"]
    let pageImages = ["Settings.png", "ThisWeekend.png", "Friends.png", "AppIcon.png"]
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create page view controller
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)

            
            
//            self.storyboard!.instantiateViewControllerWithIdentifier("LoginPageContentViewController") as LoginPageViewController
        self.pageViewController!.dataSource = self
    
        let startingViewController : LoginPageContentViewController = self.viewControllerAtIndex(0)!
        let viewControllers: NSArray = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        
        // Change the size of page view controller
        self.pageViewController!.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
        
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        self.pageViewController!.didMoveToParentViewController(self)
        
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
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as LoginPageContentViewController).pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        if index == self.pageTitles.count {
            return nil
        }
        
        return self.viewControllerAtIndex(index);
        
    }
    
    func viewControllerAtIndex(index : Int) -> LoginPageContentViewController? {
        if self.pageTitles.count == 0 || index >= self.pageTitles.count {
            return nil;
        }
        
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginPageContentViewController") as LoginPageContentViewController
        pageContentViewController.image = self.pageImages[index]
        pageContentViewController.text = self.pageTitles[index]
        pageContentViewController.pageIndex = index
        
        return pageContentViewController;
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}