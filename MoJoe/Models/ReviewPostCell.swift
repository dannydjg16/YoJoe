//
//  ReviewPostCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 3/4/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class ReviewPostCell: UITableViewCell {

    @IBOutlet weak var posterLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var roastLabel: UILabel!
    @IBOutlet weak var brewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
