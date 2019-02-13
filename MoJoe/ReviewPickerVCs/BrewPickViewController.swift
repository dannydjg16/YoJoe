//
//  BrewPickViewController.swift
//  MoJoe
//
//  Created by Daniel Grant on 2/11/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

protocol ChangeCellTextDelegate: class {
    func changeCellText(text: String)
}

class BrewPickViewController: UIViewController {

    @IBOutlet weak var brewTextField: UITextField!
    
    weak var cellDelegate: ChangeCellTextDelegate?
    
    @IBAction func addBrew(_ sender: Any) {
        cellDelegate?.changeCellText(text: brewTextField.text!)
       
       navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    

}
