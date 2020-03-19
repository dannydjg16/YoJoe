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
        
        
        let ref = Storage.storage().reference(forURL: "\(post.imageURL)")
        self.userPostPicture.setImage(from: post.imageURL)
        
//        ref.getData(maxSize: 1024 * 1024 * 1024) { data, error in
//            if let error = error {
//                print(error.localizedDescription)
//            } else if let data = data, let image = UIImage(data: data) {
//                self.userPostPicture.image = image
//                self.userPostPicture.layer.cornerRadius = self.userPostPicture.frame.height / 2
//            }
//        }
        
    }
    
    
    
}
