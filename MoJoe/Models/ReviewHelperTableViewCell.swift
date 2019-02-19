//
//  ReviewHelperTableViewCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 1/28/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class ReviewHelperTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewImage: UIImageView!
    @IBOutlet weak var reviewCategory: UILabel!
    
    func setReview(review: ReviewHelper) {
        reviewImage.image = review.reviewImage
        reviewCategory.text = review.reviewCategory
    }
    
    func returnObject(object: Any) -> Any {
        let cell = 
    }
}
