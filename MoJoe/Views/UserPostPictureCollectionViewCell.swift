//
//  UserPostPictureCollectionViewCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 1/30/20.
//  Copyright © 2020 Daniel Grant. All rights reserved.
//

import UIKit
import Firebase

class UserPostPictureCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userPostPicture: UIImageView!
    
    
    func setPostImage(post: UserGenericPost){
        
        self.userPostPicture.setImage(from: post.imageURL)
        
        userPostPicture.contentMode = .scaleAspectFill
    }
    
    
    
}
