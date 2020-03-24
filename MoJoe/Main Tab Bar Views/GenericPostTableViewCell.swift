//
//  GenericPostTableViewCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 2/11/20.
//  Copyright © 2020 Daniel Grant. All rights reserved.
//

import UIKit
import Firebase

class GenericPostTableViewCell: UITableViewCell {
    
    let user = Auth.auth().currentUser?.uid
    
    var date: String {
        get {
            let postDate = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "YYYY-MM-dd HH:mm:ss"
            let stringDate = dateFormat.string(from: postDate)
            return stringDate
        }
    }
    
    var likedPostsByUser: [String] = []
    
    @IBOutlet weak var nameButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var postExplanationLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    var postID: String = ""
    
    @IBOutlet weak var postAccentLine: UIView!
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var likesButton: UIButton!
    
 
    @IBOutlet weak var likesLabel: UILabel!
    
    
    @IBOutlet weak var commentsButton: UIButton!
    
    var commentsPageClosure: (() -> Void)?
    
   
    @IBAction func commentsButtonFunction(_ sender: Any) {
        
        self.commentsPageClosure?()
        
    }
    
    
    
    
    
    
    let userRef = Database.database().reference(withPath: "Users")
    let postsRef = Database.database().reference(withPath: "GenericPosts")
    let shopReviewRef = Database.database().reference(withPath: "ShopReview")
    let brewDebutRef = Database.database().reference(withPath: "BrewDebut")
    
    var toUserProfileTapHandler: (() -> Void)?
    
    
    @IBAction func userButtonAction(_ sender: Any) {
        self.toUserProfileTapHandler?()
    }
    
//    var postLikeClosure: (() -> Void)?
//
//
//    @IBAction func postLikeFunction(_ sender: Any) {
//
//        self.postLikeClosure?()
//
//    }
    
    
    
    
    func setGenericCell(post: UserGenericPost) {
        
        
        ratingLabel.text = String(post.rating) + "/10"
        postExplanationLabel.text = post.postExplanation
        
        self.postID = post.postID
        
        postImage.setImage(from: post.imageURL)
        
        userRef.child("\(post.userID)").child("UserPhoto").observe(.value, with: { (snapshot) in
            guard let child = snapshot.value as? String else {
               return
            }
            self.profilePic.setImage(from: child)
        })
        userRef.child("\(post.userID)").child("UserName").observe(.value, with: { (snapshot) in
            
            if let child = snapshot.value as? String {
                
                let postIDPre = post.postID.prefix(2)
                switch postIDPre {
                case "sh":
                    self.nameButton.setTitle("\(child)" + " visited...", for: .normal)
                    
                    self.shopReviewRef.child("\(post.postID)").child("likesAmount").observeSingleEvent(of: .value, with: { (dataSnapshot) in
                        
                        guard let numberOfLikes = dataSnapshot.value as? Int else {
                            return
                        }
                        
                        self.likesLabel.text = String(numberOfLikes)
                    })
                    
                    
                    
                case "br":
                    self.nameButton.setTitle("\(child)" + " brewed...", for: .normal)
                    
                    self.brewDebutRef.child("\(post.postID)").child("likesAmount").observeSingleEvent(of: .value, with: { (dataSnapshot) in
                        
                        guard let numberOfLikes = dataSnapshot.value as? Int else {
                            return
                        }
                        
                        self.likesLabel.text = String(numberOfLikes)
                    })
                    
                    
                    
                default:
                    print("nameButtonSwitch")
                }
            }
        })
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        likesButton.setImage(#imageLiteral(resourceName: "upload"), for: .normal)
        likesButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        commentsButton.setImage(#imageLiteral(resourceName: "note"), for: .normal)
        
        
        profilePic.layer.cornerRadius = profilePic.frame.height / 2
        profilePic.contentMode = .scaleAspectFill
        
        postImage.contentMode = .scaleAspectFill
        
        self.isUserInteractionEnabled = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @objc func likeButtonTapped(sender: UIButton) {
        let postIDPre = String(self.postID.prefix(2))

        switch postIDPre {
        case "sh":
             //get # of likes from database
                   self.shopReviewRef.child("\(postID)").child("likesAmount").observeSingleEvent(of: .value, with: { (dataSnapshot) in

                       guard let numberOfLikes = dataSnapshot.value as? Int else {
                           return
                       }
                       //check through the users liked posts and put them in an array
                    self.userRef.child("\(String(self.user!))").child("likedPosts").observeSingleEvent(of: .value, with: { (snapshot) in
                           var likedPostsArray : [String] = []
                           //users first like (what has to happen in cse of empty likedPosts list.)
                           if snapshot.childrenCount == 0 {
                               self.shopReviewRef.child("\(self.postID)").updateChildValues(["likesAmount": numberOfLikes + 1] )
                               //make the tab in firebase for that postID in the users likedposts
                               let likedPostDatabasePoint = self.userRef.child("\(String(self.user!))").child("likedPosts").child("\(self.postID)")

                               //set the value of the^ above point to postID: date
                               likedPostDatabasePoint.setValue(["\(self.postID)": "\(self.date)"])

                           } else {
                               for child in snapshot.children
                               {

                                   if let snapshot = child as? DataSnapshot,

                                       let value = snapshot.value as? [String: AnyObject]

                                   {
                                       for (key, value) in value {
                                           likedPostsArray.append(key)
                                       }
                                       //set the glabal var likedPostsByUser equal to the local array likedPostsArray
                                       self.likedPostsByUser = likedPostsArray
                                   }
                               }
                               //iterate through the users liked posts, if post is in the likedPosts of user, it will not run the code to add a like/add post to users liked posts
                               var hasPostBeenLiked: Bool = false
                               for post in self.likedPostsByUser {
                                   if post == self.postID {

                                       self.shopReviewRef.child("\(self.postID)").updateChildValues(["likesAmount": numberOfLikes - 1] )

                                       self.userRef.child("\(String(self.user!))").child("likedPosts").child("\(self.postID)").removeValue()

                                       hasPostBeenLiked = true
                                       continue
                                   }
                               }

                               if hasPostBeenLiked == false {

                                   self.shopReviewRef.child("\(self.postID)").updateChildValues(["likesAmount": numberOfLikes + 1] )

                                   let likedPostDatabasePoint = self.userRef.child("\(String(self.user!))").child("likedPosts").child("\(self.postID)")

                                   likedPostDatabasePoint.setValue(["\(self.postID)": "\(self.date)"])
                               }
                           }
                       })
                   })
        case "br":
            print("bd")
        default:
            print("likeButtonTapped")
        }
    }
    
}
