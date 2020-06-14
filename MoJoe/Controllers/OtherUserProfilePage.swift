//
//  OtherUserProfilePage.swift
//  MoJoe
//
//  Created by Daniel Grant on 10/9/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit
import Firebase

class OtherUserProfilePage: UIViewController {
    
    //MARK: Constants/Vars
    var userID: String = ""
    var allFolllowing: [String] = []
    var usersPosts: [UserGenericPost] = []
    var userRef = Database.database().reference(withPath: "Users")
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
    
    //MARK: Connections
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var shopsNumberLabel: UILabel!
    @IBOutlet weak var brewNumberLabel: UILabel!
    @IBOutlet weak var followingNumberLabel: UILabel!
    @IBOutlet weak var followersNumberLabel: UILabel!
    @IBOutlet weak var otherUserCollectionView: UICollectionView!
    @IBOutlet weak var followUser: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        followUser.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        followUser.layer.borderWidth = 1
        followUser.addTarget(self, action: #selector(followUserAction), for: .touchUpInside)
        
        profilePic.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        profilePic.layer.borderWidth = 1
        profilePic.layer.cornerRadius = profilePic.frame.height / 2
        profilePic.contentMode = .scaleAspectFill
        
        userRef.child("\(userID)").child("UserPosts").observe(.value
            , with: { (snapshot) in
                
                var allUserPosts: [UserGenericPost] = []
                
                for child in snapshot.children {
                    
                    if let snapshot = child as? DataSnapshot, let post = UserGenericPost(snapshot: snapshot) {
                        
                        allUserPosts.append(post)
                        
                        self.usersPosts = allUserPosts.sorted(by: {
                            $0.date > $1.date
                        })
                        self.otherUserCollectionView.reloadData()
                    }
                }
                
        })
        
        userRef.child("\(self.user!)").child("following").observeSingleEvent(of: .value, with: {
            (snapshot) in
            var followingArray: [String] = []
            
            for child in snapshot.children {
                
                if let snapshot = child as? DataSnapshot,
                    
                    let value = snapshot.value as? [String: AnyObject] {
                    
                    for (key, _) in value {
                        
                        followingArray.append(key)
                    }
                    
                    if followingArray.contains(self.userID) {
                        self.followUser.layer.backgroundColor = #colorLiteral(red: 0.8150097728, green: 0.5620573163, blue: 0.3381011486, alpha: 1)
                    } else {
                        self.followUser.layer.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.9137254902, blue: 0.8196078431, alpha: 1)
                    }
                    
                }
            }
        })
        
        userRef.child("\(userID)").child("UserName").observe(.value, with: { (snapshot) in
            
            guard let snapshot = snapshot.value as? String else {
                return
            }
            
            self.nameLabel.text = snapshot
        })
        
        userRef.child("\(userID)").child("UserPhoto").observe( .value, with: { (dataSnapshot) in
            
            guard let currentProfilePicture = dataSnapshot.value as? String else {
                return
            }
            
            self.profilePic.setImage(from: currentProfilePicture)
        })
        
        userRef.child("\(userID)").child("BDNumber").observe(.value, with: { (snapshot) in
            
            guard let numberOfBD = snapshot.value as? Int else {
                return
            }
            
            self.brewNumberLabel.text = String(numberOfBD)
        })
        
        userRef.child("\(userID)").child("SRNumber").observe(.value, with: { (snapshot) in
            
            guard let numberOfSR = snapshot.value as? Int else {
                return
            }
            
            self.shopsNumberLabel.text = String(numberOfSR)
        })
        
        userRef.child("\(userID)").child("followersNumber").observe(.value, with: { (snapshot) in
            
            guard let followersNumber = snapshot.value as? Int else {
                return
            }
            
            let numberOfFollowers = followersNumber - 1
            self.followersNumberLabel.text = String(numberOfFollowers)
        })
        
        userRef.child("\(userID)").child("followingNumber").observe(.value, with: { (snapshot) in
            
            guard let followingNumber = snapshot.value as? Int else {
                return
            }
            
            let numberOfFollowing = followingNumber - 1
            self.followingNumberLabel.text = String(numberOfFollowing)
        })
        
        
        
        
        
        
    }
    
    @objc func followUserAction(){
        
        if self.user! == self.userID {
            return
        } else {
            
            self.userRef.child("\(user!)").child("followingNumber").observeSingleEvent(of: .value, with: { (dataSnapshot) in
                
                //check for number of following. this works right now.
                guard let numberOfFollowing = dataSnapshot.value as? Int else {
                    return
                }
                
                //check through users following and put them on an array
                self.userRef.child("\(self.user!)").child("following").observeSingleEvent(of: .value, with: {
                    (snapshot) in
                    
                    var followingArray: [String] = []
                    
                    for child in snapshot.children {
                        
                        if let snapshot = child as? DataSnapshot,
                            
                            let value = snapshot.value as? [String: AnyObject] {
                            
                            for (key, _) in value {
                                followingArray.append(key)
                            }
                            self.allFolllowing = followingArray
                        }
                    }
                    
                    var hasUserBeenFollowed: Bool = false
                    
                    for otherUser in self.allFolllowing {
                        if otherUser == self.userID {
                            //MARK: Unfollow user
                            
                            //User who does the unfollowing
                            self.userRef.child("\(self.user!)").child("following").child("\(self.userID)").removeValue()
                            
                            self.userRef.child("\(self.user!)").updateChildValues(["followingNumber": numberOfFollowing - 1])
                            
                            //User who gets unfollowed
                            self.userRef.child("\(self.userID)").child("followers").child("\(self.user!)").removeValue()
                            
                            self.userRef.child("\(self.userID)").child("followersNumber").observeSingleEvent(of: .value, with: {
                                (snapshotNumber) in
                                
                                guard let numberofFollowers = snapshotNumber.value as? Int else {
                                    return
                                }
                                
                                self.userRef.child("\(self.userID)").updateChildValues(["followersNumber": numberofFollowers - 1])
                                
                            })
                            
                            hasUserBeenFollowed = true
                            break
                        }
                    }
                    if hasUserBeenFollowed == false {
                        
                        //MARK: Follow user
                        
                        //User who does the following
                        let newUserFollowingLocation = self.userRef.child("\(self.user!)").child("following").child("\(self.userID)")
                        newUserFollowingLocation.setValue(["\(self.userID)": "\(self.date)"])
                        
                        self.userRef.child("\(self.user!)").updateChildValues(["followingNumber": numberOfFollowing + 1])
                        
                        //User who gets followed
                        let newUserFollowedLocation =  self.userRef.child("\(self.userID)").child("followers").child("\(self.user!)")
                        
                        newUserFollowedLocation.setValue(["\(self.user!)": "\(self.date)"])
                        
                        self.userRef.child("\(self.userID)").child("followersNumber").observeSingleEvent(of: .value, with: {
                            (snapshotNumber) in
                            
                            guard let numberofFollowers = snapshotNumber.value as? Int else {
                                return
                            }
                            
                            self.userRef.child("\(self.userID)").updateChildValues(["followersNumber": numberofFollowers + 1])
                            
                        })
                        hasUserBeenFollowed = true
                    }
                })
            })
        }
    }
    
    
    
}


extension OtherUserProfilePage: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if usersPosts.count == 0 {
            return 1
        } else {
            return usersPosts.count
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if usersPosts.count == 0 {
            return CGSize(width: 300, height: 300)
        } else {
            return CGSize(width: 176, height: 176)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if usersPosts.count == 0 {
            
            let cell = otherUserCollectionView.dequeueReusableCell(withReuseIdentifier: "NoPostsCVC", for: indexPath)
            
            return cell
        }
        
        let post = usersPosts[indexPath.row]
        
        
        let cell = otherUserCollectionView.dequeueReusableCell(withReuseIdentifier: "OtherUserCell", for: indexPath) as! OtherUserImageCollectionViewCell
        
        cell.setCell(post: post)
        
        cell.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = cell.frame.height / 20
        
        return cell
    }
    
    
}
