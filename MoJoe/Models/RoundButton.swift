//
//  RoundButton.swift
//  FirebaseAuth
//
//  Created by Daniel Grant on 3/21/19.
//

import UIKit

@IBDesignable class RoundButton: UIButton {

    override func layoutSubviews() {
        
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    
    @IBInspectable var rounded: Bool = false {
        
        didSet {
            updateCornerRadius()
        }
    }
    
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 1.85 : 0
    }

    
}
