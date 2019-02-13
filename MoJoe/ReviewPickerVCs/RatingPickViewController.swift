//
//  RatingPickViewController.swift
//  MoJoe
//
//  Created by Daniel Grant on 2/13/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

protocol ChangeCellIntDelegate: class {
    func changeCellInt(number: Int)
}

class RatingPickViewController: UIViewController {

    
    @IBOutlet weak var coffeeRating: UISegmentedControl!
    
    weak var ratingDelegate: ChangeCellIntDelegate?
    
    
    @IBAction func ratingAdded(_ sender: Any) {
    ratingDelegate?.changeCellInt(number: coffeeRating.selectedSegmentIndex)
    navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

   

}
