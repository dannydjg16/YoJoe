//
//  RoastPickViewController.swift
//  FirebaseAuth
//
//  Created by Daniel Grant on 2/12/19.
//

import UIKit

class RoastPickViewController: UIViewController {

    
    @IBOutlet weak var roastTextField: UITextField!
    
    weak var roastDelegate: ChangeCellTextDelegate?

    @IBAction func roastPicked(_ sender: Any) {
        roastDelegate?.changeCellText(text: roastTextField.text!)

    navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    

}
