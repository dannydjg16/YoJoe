//
//  FirstReviewViewController.swift
//  MoJoe
//
//  Created by Daniel Grant on 11/23/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import UIKit

class FirstReviewViewController: UIViewController {

   
    @IBOutlet weak var tFLabel: UILabel!
    
    
    
  
    
    
    
    @IBAction func postReview(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        //think i am going to have to make a function in this function that takes 4 parameters then returns a struct called review, but that might not even be what to do, although its the best i can think of right now
        
    }
    
    struct review {
        var store: String
        var product: String
        var rating: Int
        var explainRating: String
    }
    
   
    
    var thisTF = FirstViewController.trueFalse.realTF
    
   
    @IBAction func retrieveTF(_ sender: Any) {
    
   
        
        tFLabel.text = String(thisTF)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}
