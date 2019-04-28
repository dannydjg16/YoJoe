//
//  FeedSwitcher.swift
//  MoJoe
//
//  Created by Daniel Grant on 4/22/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class FeedSwitcher: UIViewController {

    @IBOutlet weak var feedSwitcherSC: UISegmentedControl!
    
    var lastVC: UIViewController?
    
    private lazy var nearbyFeedViewController: NearbyFeedViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "NearbyFeedViewController") as! NearbyFeedViewController
        
        self.addChildVC(child: viewController)
        
        return viewController
    }()
    
    private lazy var shopsFeedView: ShopsFeedView = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let viewcontroller = storyboard.instantiateViewController(withIdentifier: "ShopsFeedView") as! ShopsFeedView
        
        self.addChildVC(child: viewcontroller)
        
        return viewcontroller
    }()
    
    private lazy var debutYourBrew: DebutYourBrew = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "DebutYourBrew") as! DebutYourBrew
        
        self.addChildVC(child: viewController)
        
        return viewController
    }()

    
    
    
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildVC(child: nearbyFeedViewController)
        lastVC = nearbyFeedViewController
        setupView()
        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    func setupView(){
        segmentSetup()
        
        loadNextView()
    }
    
    
//    private func loadNextView() {
//        if feedSwitcherSC.selectedSegmentIndex == 0 {
//           removeChildVC(child: nearbyFeedViewController)
//            addChildVC(child: shopsFeedView)
//        } else {
//            removeChildVC(child: nearbyFeedViewController)
//            addChildVC(child: shopsFeedView)
//        }
//    }
    
    private func loadNextView() {
        if feedSwitcherSC.selectedSegmentIndex == 0 {
            guard let lastView = lastVC else {return}
            //let lastView = nearbyFeedViewController
            removeChildVC(child: lastView)
            addChildVC(child: nearbyFeedViewController)
            lastVC = nearbyFeedViewController
        } else if feedSwitcherSC.selectedSegmentIndex == 1 {
            guard let lastView = lastVC else {return}
            removeChildVC(child: lastView)
            addChildVC(child: shopsFeedView)
            lastVC = shopsFeedView
        }
        else {
            guard let lastView = lastVC else {return}
            removeChildVC(child: lastView)
            addChildVC(child: debutYourBrew)
            lastVC = debutYourBrew
        }
    }

    private func segmentSetup() {
        feedSwitcherSC.removeAllSegments()
        feedSwitcherSC.insertSegment(withTitle: "Feed", at: 0, animated: false)
        feedSwitcherSC.insertSegment(withTitle: "Shops", at: 1, animated: false)
        feedSwitcherSC.insertSegment(withTitle: "Debut", at: 2, animated: false)
        feedSwitcherSC.addTarget(self, action: #selector(selectionDidChange), for: .valueChanged)
        feedSwitcherSC.setWidth(100, forSegmentAt: 0)
        feedSwitcherSC.setWidth(100, forSegmentAt: 1)
        feedSwitcherSC.setWidth(100, forSegmentAt: 2)

        feedSwitcherSC.selectedSegmentIndex = 0
    }
    
    
    
    
    @objc func selectionDidChange() {
        loadNextView()
    }
    
    
     //MARK: add/remove viewcontroller functions
    private func addChildVC(child viewController: UIViewController) {
        addChild(viewController)
        
        view.addSubview(viewController.view)
        
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        viewController.didMove(toParent: self)
    }
    
    func removeChildVC (child viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}
