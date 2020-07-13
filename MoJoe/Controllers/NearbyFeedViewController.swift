//
//  NearbyFeedViewController.swift
//  MoJoe
//
//  Created by Daniel Grant on 11/11/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation


class NearbyFeedViewController: UIViewController, CLLocationManagerDelegate{
    
    private var posts: [UserGenericPost] = []
    
    var following: [String] = []
    private let userRef = Database.database().reference(withPath: "Users")
    private let postsRef = Database.database().reference(withPath: "GenericPosts")
    private let user = Auth.auth().currentUser?.uid
    
    
    @IBOutlet private weak var shopTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.shopTableView.delegate = self
        self.shopTableView.dataSource = self
        shopTableView.allowsSelection = true
        
        
        userRef.child("\(user!)").child("following").observe(.value, with: { (snapshot) in
            
            var userFollowing: [String] = []
            //Create the follwoing array
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    userFollowing.append(snapshot.key)
                }
            }
            self.following = userFollowing
            //following array created, go through posts and check if the post's cerator is followed by the user(in the follownig array) if so then add it
            self.postsRef.queryOrdered(byChild: "date").observe(.value, with: {
                (snapshot) in
                
                var followingPosts: [UserGenericPost] = []
                
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot {
                        
                        guard let genericPost = UserGenericPost(snapshot: snapshot) else {
                            return
                        }
                        
                        if self.following.contains(genericPost.userID) {
                            followingPosts.append(genericPost)
                        }
                        
                        
                    }
                    self.posts = followingPosts.reversed()
                    self.shopTableView.reloadData()
                }
            })
            
        })
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toUserProfile",
            let profilePage = segue.destination as? OtherUserProfilePage {
            
            profilePage.userID = sender as! String
            
        } else if segue.identifier == "genericToShopComments",
            let shopReview = segue.destination as? CommentsForShopReview {
            
            shopReview.postIDFromFeed = sender as! String
            
        } else if segue.identifier == "genericToBrewComments", let brewDebut = segue.destination as? CommentsForBrewDebut {
            
            brewDebut.postIDFromFeed = sender as! String
        }
        
        
    }
}



extension NearbyFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if posts.count >= 1 {
            return posts.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if posts.count >= 1 {
            return 550
        } else {
            return 381
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = shopTableView.cellForRow(at: indexPath) as? GenericPostTableViewCell
        
        guard let postID = cell?.postID else {
            return
        }
        
        let string = String(postID.prefix(2))
        switch string {
        case "sh":
            performSegue(withIdentifier: "genericToShopComments", sender: cell?.postID)
        case "br":
            performSegue(withIdentifier: "genericToBrewComments", sender: cell?.postID)
        default:
            print("def")
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if posts.count == 0 {
            
            let cell = shopTableView.dequeueReusableCell(withIdentifier: "NoGenericPostTableViewCell", for: indexPath)
            
            return cell
            
        } else {
            
            let cell = shopTableView.dequeueReusableCell(withIdentifier: "GenericPostTVC", for: indexPath) as! GenericPostTableViewCell
            
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
            
            //MARK: Set Generic Cell
            cell.setGenericCell(post: post)
            
            //MARK: Handler Closures
            cell.toUserProfileTapHandler = {
                
                self.performSegue(withIdentifier: "toUserProfile", sender: post.userID)
                
            }
            
            cell.reportButton = {
                
                let reportAlert = UIAlertController(title: "Thank You For Reporting", message: "Post Under Review", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Back", style: .cancel, handler: nil)
                reportAlert.addAction(cancelAction)
                self.present(reportAlert, animated: true, completion: nil)
            }
            
            cell.commentsPageClosure = {
                
                let postIDPre = String(postID.prefix(2))
                switch postIDPre {
                case "sh":
                    self.performSegue(withIdentifier: "genericToShopComments", sender: postID + "addComment")
                case "br":
                    self.performSegue(withIdentifier: "genericToBrewComments", sender: postID + "addComment")
                default:
                    print("commentsPageClosure in Cell for Row at")
                }
            }
            
            let timeAgoString = Date().timeSincePost(post: post)
            cell.timeLabel.text =  timeAgoString
            
            
            return cell
        }
    }
}

