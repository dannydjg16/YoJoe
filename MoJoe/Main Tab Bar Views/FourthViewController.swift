//
//  FourthViewController.swift
//  MoJoe
//
//  Created by Denise Grant on 8/21/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import Foundation
import UIKit


class FourthViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var segmentedController: UISegmentedControl!
//    private lazy var debutYourBrew: DebutYourBrew = {
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "DebutYourBrew") as! DebutYourBrew
//
//        self.addChild(viewController)
//
//        return viewController
//    }()
    
    @IBAction func addVC(_ sender: Any) {
        //addChild(debutYourBrew)
    }
    
    @IBAction func tapHideKeyBoard(_ sender: Any) {
        self.nameTextField.resignFirstResponder()
    }
    
   //DebutYourBrew
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // Think the problem is all the other stuff that is going to limit the capabilities/what it is told to do becaus i didnt import the whole file only really the one function.(should be in the other file, whoops. it can stay here for now.)

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //handle the text field's user input through delegate callbacks
       // nameTextField.delegate = self
        
     
    }
}
    


extension FourthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}





extension FourthViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return smallViewInBigView(presentedViewController: presented, presenting: presenting)
    }
}


