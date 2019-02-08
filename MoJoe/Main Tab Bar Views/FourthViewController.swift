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
    @IBOutlet weak var mealNameLabel: UILabel!
    
   
    @IBAction func tapHideKeyBoard(_ sender: Any) {
        self.nameTextField.resignFirstResponder()
    }
    
   
    
    @IBAction func setDefaultLabelText(_ sender: Any) {
        mealNameLabel.text = "Default Text"
    }
    // Think the problem is all the other stuff that is going to limit the capabilities/what it is told to do becaus i didnt import the whole file only really the one function.(should be in the other file, whoops. it can stay here for now.)
    @IBAction func modalPresentButton(_ sender: Any) {
        let modalView = storyboard!.instantiateViewController(withIdentifier: "modalPresentView")
        modalView.transitioningDelegate = self as UIViewControllerTransitioningDelegate
        modalView.modalPresentationStyle = .custom
        
        self.present(modalView, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //handle the text field's user input through delegate callbacks
        nameTextField.delegate = self
    }
}


extension FourthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        mealNameLabel.text = nameTextField.text
    }
}





extension FourthViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return smallViewInBigView(presentedViewController: presented, presenting: presenting)
    }
}


