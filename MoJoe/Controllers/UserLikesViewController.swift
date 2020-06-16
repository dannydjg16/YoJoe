//
//  UserLikesViewController.swift
//  MoJoe
//
//  Created by Daniel Grant on 3/25/20.
//  Copyright © 2020 Daniel Grant. All rights reserved.
//

import UIKit
import Firebase

class UserLikesViewController: UIViewController {
    
    var posts: [GenericPostForLikes] = []
    var postStrings: [String] = []
    let uid = Auth.auth().currentUser?.uid
    let userRef = Database.database().reference(withPath: "Users")
    
    
    @IBOutlet weak var userLikesTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLikesTableView.layer.borderColor = #colorLiteral(red: 0.5216623545, green: 0.379847765, blue: 0.1959043145, alpha: 1)
        userLikesTableView.layer.borderWidth = 1
        
        //Create Liked Post Array
        userRef.child("\(uid!)").child("likedPosts").queryOrdered(byChild: "likeDate").observe(.value, with: {
            (snapshot) in
            
            var likedPosts: [GenericPostForLikes] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    
                    guard let likedPost = GenericPostForLikes(snapshot: snapshot) else {
                        return
                    }
                    
                    likedPosts.append(likedPost)
                }
                
                self.posts = likedPosts.reversed()
                self.userLikesTableView.reloadData()
            }
            
            
        })
        
    }
    
    
    
}


extension UserLikesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if posts.count == 0 {
            return 1
        } else {
            return posts.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if posts.count == 0 {
            return 255
        } else {
            return 550
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if posts.count == 0 {
            
            let cell = userLikesTableView.dequeueReusableCell(withIdentifier: "NoLikesTableViewCell", for: indexPath)
            
            return cell
            
        } else {
            
            let cell = userLikesTableView.dequeueReusableCell(withIdentifier: "likedPostTVC", for: indexPath) as! likedPostTableViewCell
            
            let post = posts[indexPath.row]
            
            let postID = post.postID
            let string = String(postID.prefix(2))
            
            switch string {
                
            case "sh":
                
                cell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.layer.borderWidth = 2
                cell.postAccentLine.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                
                cell.profilePic.layer.borderWidth = 0.5
                cell.profilePic.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                
            case "br":
                
                cell.layer.borderColor = #colorLiteral(red: 0.8148726821, green: 0.725468874, blue: 0.3972408772, alpha: 1)
                cell.layer.borderWidth = 2
                cell.postAccentLine.backgroundColor = #colorLiteral(red: 0.8148726821, green: 0.725468874, blue: 0.3972408772, alpha: 1)
                
                cell.profilePic.layer.borderWidth = 0.5
                cell.profilePic.layer.borderColor = #colorLiteral(red: 0.8148726821, green: 0.725468874, blue: 0.3972408772, alpha: 1)
                
            default:
                print("Border Switch")
            }
            
            cell.setGenericPostLikeCell(post: post)
            
            cell.commentsPageClosure = {
                
                let postIDPre = String(postID.prefix(2))
                switch postIDPre {
                    
                case "sh":
                    
                    let commentsPageVC: CommentsForShopReview = self.storyboard!.instantiateViewController(withIdentifier: "CommentsForShopReview") as! CommentsForShopReview
                    commentsPageVC.postIDFromFeed = postID
                    commentsPageVC.modalPresentationStyle = .popover
                    
                    self.present(commentsPageVC, animated: true, completion: nil)
                    
                case "br":
                    
                    let commentsPageVC: CommentsForBrewDebut = self.storyboard!.instantiateViewController(withIdentifier: "CommentsForBrewDebut") as! CommentsForBrewDebut
                    commentsPageVC.postIDFromFeed = postID
                    commentsPageVC.modalPresentationStyle = .popover
                    
                    self.present(commentsPageVC, animated: true, completion: nil)
                    
                default:
                    print("commentsPageClosure in Cell for Row at")
                }
            }
            
            let timeAgoString = Date().timeSinceLikedGenericPost(post: post)
            cell.timeLabel.text =  timeAgoString
            
            return cell
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = userLikesTableView?.cellForRow(at: indexPath) as? likedPostTableViewCell
        
        guard let postID = cell?.postID else {
            return
        }
        
        let string = String(postID.prefix(2))
        switch string {
            
        case "sh":
            
            let commentsPageVC: CommentsForShopReview = self.storyboard!.instantiateViewController(withIdentifier: "CommentsForShopReview") as! CommentsForShopReview
            commentsPageVC.postIDFromFeed = postID
            commentsPageVC.modalPresentationStyle = .pageSheet
            
            self.present(commentsPageVC, animated: true, completion: nil)
            
        case "br":
            
            let commentsPageVC: CommentsForBrewDebut = self.storyboard!.instantiateViewController(withIdentifier: "CommentsForBrewDebut") as! CommentsForBrewDebut
            commentsPageVC.postIDFromFeed = postID
            commentsPageVC.modalPresentationStyle = .pageSheet
            
            self.present(commentsPageVC, animated: true, completion: nil)
            
        default:
            print("didselesctrow")
        }
    }
    
}
