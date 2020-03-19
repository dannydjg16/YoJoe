//
//  profilePostImage.swift
//  Alamofire
//
//  Created by Daniel Grant on 1/26/20.
//

import UIKit
import Firebase


class profilePostImage: UICollectionViewCell {
    
    let ref = Database.database().reference(withPath: "")
    
    @IBOutlet weak var postImage: UIImageView!
    
    
    
    
    func setImage(postID: UserGenericPost) {
       
        
        
        
        let ref = Storage.storage().reference(forURL: "\(postID.imageURL)")
        
        
        ref.getData(maxSize: 1024 * 1024 * 1024) { data, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data, let image = UIImage(data: data) {
                self.postImage.image = image
                self.postImage.layer.cornerRadius = self.postImage.frame.height / 2
            } }
  
    }
    
    
    
}
