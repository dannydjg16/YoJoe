//
//  SRReviewCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 4/28/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class SRReviewCell: UITableViewCell {

    
    @IBOutlet weak var reviewTextField: UITextField!
    
  
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        
        reviewTextField.contentVerticalAlignment = .top
        reviewTextField.textAlignment = .left
        self.reviewTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}


extension SRReviewCell: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        reviewTextField.resignFirstResponder()
        
        return true
    }
}
