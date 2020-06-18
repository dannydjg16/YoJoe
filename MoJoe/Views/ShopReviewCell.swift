//
//  ShopReviewCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 4/28/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit
import Firebase 

class ShopReviewCell: UITableViewCell {
    
    //MARK: Constants/Vars
    var postID: String = ""
    var imageURL: String = ""
    var likedPostsByUser: [String] = []
    var genericReview: GenericPostForLikes = GenericPostForLikes(date: "", imageURL: "", postID: "", userID: "", postExplanation: "", rating: 0, reviewType: "", likeDate: "")
    
    var tapHandler: (() -> Void)?
    var toUserProfileTapHandler: (() -> Void)?
    var reportButton: (() -> Void)?
    
    let ref = Database.database().reference(withPath: "ShopReview")
    let userRef = Database.database().reference(withPath: "Users")
    let postLikesRef = Database.database().reference(withPath: "PostLikes")
    let reportRef = Database.database().reference(withPath: "Reports")
    let user = Auth.auth().currentUser
    
    var date: String {
        get {
            let postDate = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "YYYY-MM-dd HH:mm:ss"
            let stringDate = dateFormat.string(from: postDate)
            return stringDate
        }
    }

    
    //MARK: Connections
    @IBOutlet weak var userVisitedButton: UIButton!
    @IBOutlet weak var coffeeShopLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var coffeeTypeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timeSinceLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var shopPicture: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!

    
    @IBAction func toCommentsPage(_ sender: Any) {
        
        self.tapHandler?()
    }
    
    @IBAction func userVisitedButton(_ sender: Any) {
        
        self.toUserProfileTapHandler?()
    }
    
    @IBAction func reportButtonPressed(_ sender: Any) {
        
        let reportLocation = reportRef.child("\(self.postID)")
        reportLocation.setValue(["\(self.postID)": date])
        
        self.reportButton?()
    }
    
    
    
    func setShopReviewCell(review: ShopReivew) {
        
        coffeeShopLabel.text = review.shop
        cityLabel.text = review.city + ","
        stateLabel.text = review.state
        coffeeTypeLabel.text = review.coffeeType
        ratingLabel.text = "\(String(review.rating)) / 10"
        likesLabel.text = "0"
        postID = review.postID
        
        genericReview = GenericPostForLikes(date: review.date, imageURL: review.imageURL, postID: review.postID, userID: review.user, postExplanation: review.review, rating: review.rating, reviewType: "shopReview", likeDate: date)
        
        shopPicture.setImage(from: review.imageURL)
        
        postLikesRef.child("\(review.postID)").child("likesAmount").observe(.value, with: {
            (dataSnapshot) in
            
            guard let numberOfLikes = dataSnapshot.value as? Int else {
                return
            }
            
            self.likesLabel.text = String(numberOfLikes)
        })
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilePic.layer.cornerRadius = profilePic.frame.height / 2
        profilePic.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        profilePic.layer.borderWidth = 0.5
        profilePic.contentMode = .scaleAspectFill
        
        shopPicture.contentMode = .scaleAspectFill
        
        likeButton.setImage(#imageLiteral(resourceName: "upload"), for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        commentsButton.setImage(#imageLiteral(resourceName: "note"), for: .normal)
        
        //set image stuff of like button based on wehther it is liked or not
        self.userRef.child("\(String(self.user!.uid))").child("likedPosts").observe(.value, with: { (snapshot) in
           
            var likedPostsArray : [String] = []
            
            for child in snapshot.children
            {
                
                if let snapshot = child as? DataSnapshot,
                    
                    let valueDictionary = snapshot.value as? [String: AnyObject]
                    
                {
                    likedPostsArray.append(valueDictionary["postID"] as! String)
                }
        
                self.likedPostsByUser = likedPostsArray
            }
            
            if likedPostsArray.contains(self.postID) {
                
                self.likeButton.layer.borderWidth = 1
                self.likeButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                
            } else {
                
                self.likeButton.layer.borderWidth = 0
            }
        })
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    @objc func likeButtonTapped(sender: UIButton) {
        //get # of likes from database
        self.postLikesRef.child("\(postID)").child("likesAmount").observeSingleEvent(of: .value, with: { (dataSnapshot) in
            
            guard let numberOfLikes = dataSnapshot.value as? Int else {
                return
            }
            //check through the users liked posts and put them in an array
            self.userRef.child("\(String(self.user!.uid))").child("likedPosts").observeSingleEvent(of: .value, with: { (snapshot) in
                
                var likedPostsArray : [String] = []
                //users first like (what has to happen in cse of empty likedPosts list.)
                if snapshot.childrenCount == 0 {
                    
                    self.postLikesRef.child("\(self.postID)").updateChildValues(["likesAmount": numberOfLikes + 1])
                    
                    
                    let likedPostDatabasePoint = self.userRef.child("\(String(self.user!.uid))").child("likedPosts").child("\(self.postID)")
                    let genericLikedPost = self.genericReview
                    
                    likedPostDatabasePoint.setValue(genericLikedPost.makeDictionary())
                    
                } else {
                    for child in snapshot.children
                    {
                        
                        if let snapshot = child as? DataSnapshot,
                            
                            let valueDictionary = snapshot.value as? [String: AnyObject]
                            
                        {
                            
                            likedPostsArray.append(valueDictionary["postID"] as! String)
                            
                        }
                        //set the glabal var likedPostsByUser equal to the local array likedPostsArray
                        self.likedPostsByUser = likedPostsArray
                    }
                    
                    var hasPostBeenLiked: Bool = false
                    
                    for post in self.likedPostsByUser {
                        
                        if post == self.postID {
                            
                            self.postLikesRef.child("\(self.postID)").updateChildValues(["likesAmount": numberOfLikes - 1] )
                            
                            self.userRef.child("\(String(self.user!.uid))").child("likedPosts").child("\(self.postID)").removeValue()
                            
                            hasPostBeenLiked = true
                            
                            continue
                        }
                    }
                    
                    if hasPostBeenLiked == false {
                        
                        self.postLikesRef.child("\(self.postID)").updateChildValues(["likesAmount": numberOfLikes + 1] )
                        
                        let likedPostDatabasePoint = self.userRef.child("\(String(self.user!.uid))").child("likedPosts").child("\(self.postID)")
                        let genericLikedPost = self.genericReview
                        
                        likedPostDatabasePoint.setValue(genericLikedPost.makeDictionary())
                    }
                }
            })
        })
    }
    
    
}
