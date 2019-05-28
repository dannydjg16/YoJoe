//
//  SingleLabelCollectionViewCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 4/30/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class SingleLabelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coffeeTypeLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.frame.size.width / 15

    }
    
}
