//
//  PostCellOnCommentsPage.swift
//  MoJoe
//
//  Created by Daniel Grant on 8/6/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit
import Firebase

class PostCellOnCommentsPage: UITableViewCell {

    //MARK:Constants/Vars
    private var userRef = Database.database().reference(withPath: "Users")
    
    
    //MARK: Connections
    @IBOutlet private weak var userPic: UIImageView!
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var coffeeShopLabel: UILabel!
    @IBOutlet private weak var coffeeType: UILabel!
    
    
    func setShopReviewCommentCell(review: ShopReivew) {
        
        userLabel.text = "\(review.user) reviewed..."
        coffeeShopLabel.text = review.shop
        coffeeType.text = review.coffeeType
        
        self.userRef.child("\(review.user)").child("UserPhoto").observeSingleEvent(of: .value, with: {(dataSnapshot) in
            
            guard let currentProfilePicture = dataSnapshot.value as? String else {
                return
            }
            
            self.userPic.setImage(from: currentProfilePicture)
        })
        
    }
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }

    
}
