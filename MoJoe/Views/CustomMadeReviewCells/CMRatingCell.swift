//
//  CMRatingCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 3/24/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class CMRatingCell: UITableViewCell {

    @IBOutlet private weak var ratingSlider: UISlider!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBAction private func setRating(_ sender: UISlider) {
        
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
