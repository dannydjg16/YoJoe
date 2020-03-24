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
    
    var tapHandler: (() -> Void)?
    
    @IBAction func toCommentsPage(_ sender: Any) {
        
        self.tapHandler?()
    }
    
    
    var toUserProfileTapHandler: (() -> Void)?
    
    @IBAction func userVisitedButton(_ sender: Any) {
        
        self.toUserProfileTapHandler?()
        
    }
 
    var postID: String = ""
    var imageURL: String = ""
    
    
    
    var genericReview: GenericPostForLikes = GenericPostForLikes(date: "", imageURL: "", postID: "", userID: "", postExplanation: "", rating: 0, reviewType: "", likeDate: "")

    
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
    
    @IBOutlet weak var postActivityBar: UIView!

    
    
    @IBOutlet weak var shopPicture: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
   
    
  
    
    let ref = Database.database().reference(withPath: "ShopReview")
    let userRef = Database.database().reference(withPath: "Users")
    let user = Auth.auth().currentUser
    
    
    func setShopReviewCell(review: ShopReivew) {
    
        
        coffeeShopLabel.text = review.shop
        cityLabel.text = review.city + ","
        stateLabel.text = review.state
        coffeeTypeLabel.text = review.coffeeType
    
        //orderLabel.text = review.review
        ratingLabel.text = "\(String(review.rating)) / 10"
        //shopPicture.image = #imageLiteral(resourceName: "coffeeCup")
        likesLabel.text = "0"//review.likesAmount or whatever i decide to call it.
        postID = review.postID
        genericReview = GenericPostForLikes(date: review.date, imageURL: review.imageURL, postID: review.postID, userID: review.user, postExplanation: review.review, rating: review.rating, reviewType: "shopReview", likeDate: date)
        
        shopPicture.setImage(from: review.imageURL)

        
        
        self.ref.child("\(review.postID)").child("likesAmount").observeSingleEvent(of: .value, with: { (dataSnapshot) in
            
            guard let numberOfLikes = dataSnapshot.value as? Int else {
                return
            }
            
            self.likesLabel.text = String(numberOfLikes)
        })
       
        
    }
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profilePic.layer.cornerRadius = profilePic.frame.height / 2
        
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
                    
                    let value = snapshot.value as? [String: AnyObject]
                    
                {
                    for (key, value) in value {
                        likedPostsArray.append(key) }
                    //set the glabal var likedPostsByUser equal to the local array likedPostsArray
                    self.likedPostsByUser = likedPostsArray
                }}
            //iterate through the users liked posts, if post is in the likedPosts of user, it will not run the code to add a like/add post to users liked posts
            var hasPostBeenLiked: Bool = false
            for post in self.likedPostsByUser {
                if post == self.postID {
                    hasPostBeenLiked = true
                    continue
                }
            }
           
        })
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }

    
    @objc func likeButtonTapped(sender: UIButton) {
        //get # of likes from database
        self.ref.child("\(postID)").child("likesAmount").observeSingleEvent(of: .value, with: { (dataSnapshot) in
            
            guard let numberOfLikes = dataSnapshot.value as? Int else {
                return
            }
            //check through the users liked posts and put them in an array
             self.userRef.child("\(String(self.user!.uid))").child("likedPosts").observeSingleEvent(of: .value, with: { (snapshot) in
                var likedPostsArray : [String] = []
                //users first like (what has to happen in cse of empty likedPosts list.)
                if snapshot.childrenCount == 0 {
                    self.ref.child("\(self.postID)").updateChildValues(["likesAmount": numberOfLikes + 1] )
                    //make the tab in firebase for that postID in the users likedposts
                    let likedPostDatabasePoint = self.userRef.child("\(String(self.user!.uid))").child("likedPosts").child("\(self.postID)")
                    
                    //set the value of the^ above point to postID: date
                    let genericLikedPost = self.genericReview
                    likedPostDatabasePoint.setValue(genericLikedPost.makeDictionary())
                    
                } else {
                    //These next few lines are what happens when there is at least one like on the post. "else" above is that split
                    for child in snapshot.children
                        //^child is the usersLikedPosts. now i have to decide what to do with each of the posts. probably
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
                           
                            self.ref.child("\(self.postID)").updateChildValues(["likesAmount": numberOfLikes - 1] )
                            
                            self.userRef.child("\(String(self.user!.uid))").child("likedPosts").child("\(self.postID)").removeValue()
                            
                            hasPostBeenLiked = true
                            continue
                        }
                    }
                    
                    if hasPostBeenLiked == false {
                        
                        self.ref.child("\(self.postID)").updateChildValues(["likesAmount": numberOfLikes + 1] )
                        
                        //make the tab in firebase for that postID in the users likedposts
                        let likedPostDatabasePoint = self.userRef.child("\(String(self.user!.uid))").child("likedPosts").child("\(self.postID)")
                        
                        //set the value of the^ above point to postID: date
                        let genericLikedPost = self.genericReview
                        likedPostDatabasePoint.setValue(genericLikedPost.makeDictionary())
                    }
                }
            })
        })
    }
    

    
    @objc func repostButtonTapped(sender: UIButton) {
        print("repostButtonTapped")
    }
}
