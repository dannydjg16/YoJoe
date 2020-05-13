//
//  ReviewHelper.swift
//  MoJoe
//
//  Created by Daniel Grant on 1/28/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import Foundation
import UIKit


class ReviewHelper {
   
    var reviewImage: UIImage
    var reviewCategory: String
    
    init(reviewImage: UIImage, reviewCategory: String) {
        
        self.reviewImage = reviewImage
        self.reviewCategory = reviewCategory
    }
}
