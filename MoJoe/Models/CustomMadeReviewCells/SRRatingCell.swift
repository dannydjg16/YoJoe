//
//  SRRatingCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 4/28/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class SRRatingCell: UITableViewCell {

    
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var ratingLabel: UILabel!
  
    @IBAction func setRating(_ sender: UISlider) {
        
        let coffeeRating = Int(sender.value)
        
        ratingLabel.text = "\(coffeeRating)"
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    
}
