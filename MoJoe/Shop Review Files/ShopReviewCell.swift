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

    @IBOutlet weak var userVisitedLabel: UILabel!
    @IBOutlet weak var coffeeShopLabel: UILabel!
    @IBOutlet weak var coffeeTypeLabel: UILabel!
    @IBOutlet weak var shopTagsLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timeSinceLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var commentsButton: UIButton!
    
    var tapHandler: (() -> Void)?
    
    
    
    @IBAction func toCommentsPage(_ sender: Any) {
        
        
        self.tapHandler?()
    }
    
    
    
    @IBOutlet weak var repostButton: UIButton!
    
    var postID: String = ""
    var imageURL: String = ""
    
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
    
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    @IBOutlet weak var shopPicture: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var shopTagsCollectionView: UICollectionView!
    
    var shopTagsArray: [String] = []
    
    let ref = Database.database().reference(withPath: "ShopReview")
    let userRef = Database.database().reference(withPath: "Users")
    let user = Auth.auth().currentUser
    
    func setShopReviewCell(review: ShopReivew) {
        
        
        //set the imageURL
        
        
        
        coffeeShopLabel.text = review.shop
        coffeeTypeLabel.text = review.coffeeType
        //orderLabel.text = review.review
        ratingLabel.text = "\(String(review.rating)) / 10!"
        //shopPicture.image = #imageLiteral(resourceName: "coffeeCup")
        likesLabel.text = "0"//review.likesAmount or whatever i decide to call it.
        postID = review.postID
        
        
        
        self.ref.child("\(review.postID)").child("imageURL").observeSingleEvent(of: .value, with: { (dataSnapshot) in
            
            guard let imageURL = dataSnapshot.value as? String else {
                return
            }
            
            //Now that I have the imageURL I just need to get it from storage.
            let ref = Storage.storage().reference(forURL: imageURL)
            
            ref.getData(maxSize: 1024 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data, let image = UIImage(data: data) {
                    self.shopPicture.image = image
                } }
                
            
        })
        
        
        self.ref.child("\(review.postID)").child("likesAmount").observeSingleEvent(of: .value, with: { (dataSnapshot) in
            
            guard let numberOfLikes = dataSnapshot.value as? Int else {
                return
            }
            
            self.likesLabel.text = String(numberOfLikes)
        })
        
        switch review.coffeeType {
        case "Cappucino", "Americano":
            self.cupPic.image = #imageLiteral(resourceName: "coffee")
        case "Latte", "Hot Coffee":
            self.cupPic.image = #imageLiteral(resourceName: "iced-coffee")
        default:
            return
        }
        
    }
    
    
    
    
    
    
    
    @IBOutlet weak var cupPic: UIImageView!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profilePic.layer.cornerRadius = profilePic.frame.height / 2
        
        self.cupPic.image = #imageLiteral(resourceName: "coffee")
        self.shopTagsCollectionView.delegate = self
        self.shopTagsCollectionView.dataSource = self
        //self.shopTagsCollectionView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.shopTagsCollectionView.layer.borderWidth = 0
        self.shopTagsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
       
       
        postActivityBar.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        postActivityBar.layer.borderWidth = 1
       
        
      
        likeButton.setImage(#imageLiteral(resourceName: "upload"), for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        commentsButton.setImage(#imageLiteral(resourceName: "note"), for: .normal)
        //commented out and used ibaction instead
        //commentsButton.addTarget(self, action: #selector(commentsButtonTapped), for: .touchUpInside)
        
        repostButton.setImage(#imageLiteral(resourceName: "promotion"), for: .normal)
        repostButton.addTarget(self, action: #selector(repostButtonTapped), for: .touchUpInside)
        
        //set image stuff of like button based on wehther it is liked or not
        self.userRef.child("\(String(self.user!.uid))").child("likedPosts").observe(.value, with: { (snapshot) in
            var likedPostsArray : [String] = []
            
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
                    hasPostBeenLiked = true
                    continue
                }
            }
            if hasPostBeenLiked == true {
                self.likeButton.layer.backgroundColor = #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1)
            } else {
                self.likeButton.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
       
       )
        
     
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
    
    //commented out and used ibaction instead
//    @objc func commentsButtonTapped(sender: UIButton) {
//        print("commentsButtonTapped")
//        var cellName = postID
//        self.tapHandler?()
//
//    }
    
    @objc func repostButtonTapped(sender: UIButton) {
        print("repostButtonTapped")
    }
}


extension ShopReviewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func borderSet(cell: UICollectionViewCell, color: UIColor, width: Int) {
        cell.layer.borderColor = color.cgColor
        cell.layer.borderWidth = CGFloat(width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopTagsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tag = self.shopTagsArray[indexPath.row]
        
        let shopTagCollectionViewCell = shopTagsCollectionView.dequeueReusableCell(withReuseIdentifier: "ShopTagReviewFeedCVCell", for: indexPath) as! ShopTagReviewFeedCVCell
    
        shopTagCollectionViewCell.shopTagLabel.text = tag
       
        borderSet(cell: shopTagCollectionViewCell, color: #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1), width: 1)
        
        return shopTagCollectionViewCell

        
    }


}
