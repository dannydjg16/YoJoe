//
//  ModalHelperViewController.swift
//  MoJoe
//
//  Created by Daniel Grant on 1/31/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

protocol cellTextDelegate: class {
    func changeText(text: String)
}

class ModalHelperViewController: UIViewController {

    weak var textDelegate: cellTextDelegate?
    
    @IBOutlet weak var reviewTextField: UITextField!
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //this will eventually turn into something else, right now im just wokring on the logic of sending whatever is typed/selected on the modal view to the review vc
    @IBAction func reviewSendButton(_ sender: Any) {
//probably a problem, but i am force unwrapping the textfield and its gonna need to have some text already in it or crash. 
        textDelegate?.changeText(text: reviewTextField.text!)
        
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    


}
