//
//  SRLocationCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 4/28/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class SRLocationCell: UITableViewCell {

    
    @IBOutlet weak var locationTextField: UITextField!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       self.locationTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

}


extension SRLocationCell: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        locationTextField.resignFirstResponder()
        
        return true
    }
}
