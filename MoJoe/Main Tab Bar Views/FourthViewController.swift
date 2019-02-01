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
    
    @IBAction func modalPresentButton(_ sender: Any) {
        let modalView = storyboard?.instantiateViewController(withIdentifier: "modalPresentView") as! UIViewController
        modalView.transitioningDelegate = self as! UIViewControllerTransitioningDelegate
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


//Might want to move this into a class by itself, but for now i feel like there isnt really a problem with it being here.
class smallViewInBigView: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        get {
            guard let view = containerView else {
                return CGRect.zero
            }
            return CGRect(x: 0, y: view.bounds.height/3 , width: view.bounds.width, height: view.bounds.height/3 )
        }
    }
}
