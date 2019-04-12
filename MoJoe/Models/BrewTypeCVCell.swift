//
//  BrewTypeCVCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 3/26/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class BrewTypeCVCell: UICollectionViewCell {
  
    @IBOutlet weak var brewImage: UIImageView!
    @IBOutlet weak var brewName: UILabel!
    
    func setCell(brew: ReviewHelper) {
        brewImage.image = brew.reviewImage
        brewName.text = brew.reviewCategory
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.frame.size.width / 3
        
    }
}
