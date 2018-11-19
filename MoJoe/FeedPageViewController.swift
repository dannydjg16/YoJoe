//
//  FeedPageViewController.swift
//  MoJoe
//
//  Created by Daniel Grant on 11/15/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import Foundation
import UIKit

class FeedPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
   
    //this is making an array of the view controllers that I made and want to be apart of the page view controller
    lazy var feedViewContollers: [UIViewController] = {
        return [self.newVc(viewController: "FirstViewController"), self.newVc(viewController: "NearbyFeedViewController")]
    }()
    
    //this one loads the view controllers as you scroll thorugh different views
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    
    //This one and the other labaeled one are there so that this class can conform to datasource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = feedViewContollers.index(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return feedViewContollers.last
        }
        
        guard feedViewContollers.count > previousIndex else {
            return nil
        }
        return feedViewContollers[previousIndex]
    }
    
    //this is the other one i mentioned that is a part of datasource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = feedViewContollers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let feedViewControllersCount = feedViewContollers.count
        
        guard feedViewControllersCount != nextIndex else {
            return feedViewContollers.first
        }
        
        guard feedViewControllersCount > nextIndex else {
            return nil
        }
        return feedViewContollers[nextIndex]
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        //this gave me some trouble, I had a hard time becuase I had to take away one part of the setViewControllers method. An
        if let firstViewController = feedViewContollers.first {
            setViewControllers([firstViewController], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        }
        
    }
    
    
}
