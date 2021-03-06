//
//  OtherUserImageCollectionViewCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 2/1/20.
//  Copyright © 2020 Daniel Grant. All rights reserved.
//

import UIKit

class OtherUserImageCollectionViewCell: UICollectionViewCell {
    
    var postID: String = ""
    
    @IBOutlet weak var postPhoto: UIImageView!
    
    
    func setCell(post: UserGenericPost) {
        
        postPhoto.setImage(from: post.imageURL)
        postID = post.postID
        
        postPhoto.contentMode = .scaleAspectFill
    }
    
    
}
