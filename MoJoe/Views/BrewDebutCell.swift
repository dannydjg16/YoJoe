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
   
    //MARK: Constants/Vars
    private let ref = Database.database().reference(withPath: "BrewDebut")
    private let userRef = Database.database().reference(withPath: "Users")
    private let postLikesRef = Database.database().reference(withPath: "PostLikes")
    private let reportRef = Database.database().reference(withPath: "Reports")
    
    var postID: String = ""
    var imageURL: String = ""
    private var genericReview: GenericPostForLikes = GenericPostForLikes(date: "", imageURL: "", postID: "", userID: "", postExplanation: "", rating: 0, reviewType: "", likeDate: "")
    private let user = Auth.auth().currentUser
    
    var likedPostsByUser: [String] = []
    var tapHandler: (() -> Void)?
    var toUserProfileTapHandler: (() -> Void)?
    var reportButton: (() -> Void)?
    
    private var date: String {
        get {
            let postDate = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "YYYY-MM-dd HH:mm:ss"
            let stringDate = dateFormat.string(from: postDate)
            return stringDate
        }
    }
    
    
    //MARK: Connections
    @IBOutlet weak var userBrewedLabel: UIButton!
    @IBOutlet private weak var brewLabel: UILabel!
    @IBOutlet private weak var roastLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet private weak var beanLocationLabel: UILabel!
    @IBOutlet private weak var brewPicture: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var commentsButton: UIButton!
    @IBOutlet private weak var brewTakePic: UIImageView!
    @IBOutlet private weak var likesLabel: UILabel!
    
    
    @IBAction func toCommentsPage(_ sender: Any) {
        
        self.tapHandler?()
    }
    
    @IBAction func otherUserButton(_ sender: Any) {
        
        self.toUserProfileTapHandler?()
    }
    
    @IBAction func reportButtonPressed(_ sender: Any) {
        
        let reportLocation = reportRef.child("\(self.postID)")
        reportLocation.setValue(["\(self.postID)": date])
        
        self.reportButton?()
    }
    
    
    func setDebutCell(debut: BrewDebut){
        
        brewLabel.text = debut.brew
        roastLabel.text = debut.roast
        ratingLabel.text = "\(String(debut.rating)) / 10"
        beanLocationLabel.text = debut.beanLocation
        postID = debut.postID
        genericReview = GenericPostForLikes(date: debut.date, imageURL: debut.imageURL, postID: debut.postID, userID: debut.user, postExplanation: debut.review, rating: debut.rating, reviewType: "shopReview", likeDate: date)
        
        brewTakePic.setImage(from: debut.imageURL)
        
        self.postLikesRef.child("\(debut.postID)").child("likesAmount").observe(.value, with: { (dataSnapshot) in
            
            guard let numberOfLikes = dataSnapshot.value as? Int else {
                return
            }
            
            self.likesLabel.text = String(numberOfLikes)
        })
    
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilePic.layer.cornerRadius = profilePic.frame.height / 2
        profilePic.layer.borderWidth = 0.5
        profilePic.layer.borderColor = #colorLiteral(red: 0.8148726821, green: 0.725468874, blue: 0.3972408772, alpha: 1)
        profilePic.contentMode = .scaleAspectFill
        
        likeButton.setImage(#imageLiteral(resourceName: "upload"), for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        commentsButton.setImage(#imageLiteral(resourceName: "note"), for: .normal)
        
        brewPicture.contentMode = .scaleAspectFill
        
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
                //set the glabal var likedPostsByUser equal to the local array likedPostsArray
                self.likedPostsByUser = likedPostsArray
            }
            
            if likedPostsArray.contains(self.postID) {
                
                self.likeButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.likeButton.layer.borderWidth = 1
            } else {
                self.likeButton.layer.borderWidth = 0
            }
            
        })
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    @objc private  func likeButtonTapped(sender: UIButton) {
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
                    
                    self.postLikesRef.child("\(self.postID)").updateChildValues(["likesAmount": numberOfLikes + 1] )
                    
                    //make the tab in firebase for that postID in the users likedposts
                    let likedPostDatabasePoint = self.userRef.child("\(String(self.user!.uid))").child("likedPosts").child("\(self.postID)")
                    
                    //set the value of the^ above point to postID: date
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
                    //iterate through the users liked posts, if post is in the likedPosts of user, it will not run the code to add a like/add post to users liked posts
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
