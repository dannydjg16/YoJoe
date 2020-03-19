//
//  SecondViewController.swift
//  MoJoe
//
//  Created by Denise Grant on 8/21/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate {

  
    @IBOutlet weak var searchForShops: UISearchBar!
    @IBOutlet weak var searchTField: UITextField!
    
  
  
    
    
    
    
    @IBAction func tapHideKeyboard(_ sender: Any) {
        self.searchForShops.resignFirstResponder()
        self.searchTField.resignFirstResponder()
     
    }
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        
    }
    
    private lazy var debutYourBrew: DebutYourBrew = {
              let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
              let viewController = storyboard.instantiateViewController(withIdentifier: "DebutYourBrew") as! DebutYourBrew
      
             self.add(asChildViewController: viewController)
      
              return viewController
          }()
      
    
      
      private func add(asChildViewController viewController: UIViewController) {
          // Add Child View Controller
          addChild(viewController)
          
          // Add Child View as Subview
          view.addSubview(viewController.view)
          
          // Configure Child View
          viewController.view.frame = view.bounds
          viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
          
          // Notify Child View Controller
          viewController.didMove(toParent: self)
      }
    @IBAction func presentViewController(_ sender: Any) {
        addChild(debutYourBrew)
    }
    

    private func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        
        self.searchForShops.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        return true
    }
    //2) this function runs when the text field returns true after it is no longer the first responder
    func textFieldDidEndEditing(_ textField: UITextField)  {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeHandler))
        downSwipe.direction = .down
        self.view.addGestureRecognizer(downSwipe)
        
    }

    @objc func swipeHandler(gesture: UISwipeGestureRecognizer){
        switch gesture.direction {
        case .down :
            searchTField.resignFirstResponder()
        default:
            break
        }
    }
}

