//
//  CMRcell.swift
//  MoJoe
//
//  Created by Daniel Grant on 3/24/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class CMRCell: UITableViewCell {

  
    
    
    @IBOutlet weak var reviewTextField: UITextField!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.reviewTextField.delegate = self
       reviewTextField.contentVerticalAlignment = .top
        reviewTextField.textAlignment = .left
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

}

extension CMRCell: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}

