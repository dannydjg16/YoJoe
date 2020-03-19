//
//  BrewDebutCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 4/26/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit
import Firebase

class BrewDebutCell: UITableViewCell {
    
    @IBOutlet weak var userBrewedLabel: UIButton!
    
    @IBOutlet weak var brewLabel: UILabel!
    @IBOutlet weak var roastLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var beanLocationLabel: UILabel!
    
    
    
    
    @IBOutlet weak var brewPicture: UIImageView!
   
    @IBOutlet weak var profilePic: UIImageView!
    
   
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
 
    
    let ref = Database.database().reference(withPath: "BrewDebut")
    let userRef = Database.database().reference(withPath: "Users")
    var postID: String = ""
    var imageURL: String = ""
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
 
    @IBOutlet weak var brewTakePic: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    
    var likedPostsByUser: [String] = []
    
    @IBOutlet weak var postActivityBar: UIView!

    
    var tapHandler: (() -> Void)?
    
    @IBAction func toCommentsPage(_ sender: Any) {
        self.tapHandler?()
    }
    
     var toUserProfileTapHandler: (() -> Void)?
    
    @IBAction func otherUserButton(_ sender: Any) {
        
        self.toUserProfileTapHandler?()
        
    }
    
    
    

    
    func setDebutCell(debut: BrewDebut){
        
        
        brewLabel.text = debut.brew
        roastLabel.text = debut.roast
        ratingLabel.text = "\(String(debut.rating)) / 10"
        
        beanLocationLabel.text = debut.beanLocation
        postID = debut.postID
        brewTakePic.setImage(from: debut.imageURL)
        
        

        
        self.ref.child("\(debut.postID)").child("likesAmount").observeSingleEvent(of: .value, with: { (dataSnapshot) in
            
            guard let numberOfLikes = dataSnapshot.value as? Int else {
                return
            }
            
            self.likesLabel.text = String(numberOfLikes)
        })
        
        
        
        
       
        
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
       self.profilePic.layer.cornerRadius = profilePic.frame.height / 2
        
//        postActivityBar.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        postActivityBar.layer.borderWidth = 1
        


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
           if hasPostBeenLiked == true {
               self.likeButton.layer.backgroundColor = #colorLiteral(red: 0.8148726821, green: 0.725468874, blue: 0.3972408772, alpha: 1)
           } else {
               self.likeButton.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
           }
       })
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
                    
                    let likedPostDatabasePoint = self.userRef.child("\(String(self.user!.uid))").child("likedPosts").child("\(self.postID)")
                    
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
                            print("liked already")
                            
                            self.ref.child("\(self.postID)").updateChildValues(["likesAmount": numberOfLikes - 1] )
                            
                            self.userRef.child("\(String(self.user!.uid))").child("likedPosts").child("\(self.postID)").removeValue()
                            
                            hasPostBeenLiked = true
                            continue
                        }
                    }
                    if hasPostBeenLiked == false {
                        self.ref.child("\(self.postID)").updateChildValues(["likesAmount": numberOfLikes + 1] )
                        
                        let likedPostDatabasePoint = self.userRef.child("\(String(self.user!.uid))").child("likedPosts").child("\(self.postID)")
                        
                        likedPostDatabasePoint.setValue(["\(self.postID)": "\(self.date)"])
                    }
                }
            })
        })
    }
    
    
    @objc func repostButtonTapped(sender: UIButton) {
        print("repostButtonTapped")
    }
    
}
