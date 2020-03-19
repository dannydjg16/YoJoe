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
    
    var posts: [UserGenericPost] = []
    var shopReviews: [ShopReivew] = []
    var following: [String] = []
    var postsStrings: [String] = []
    let shopReviewRef = Database.database().reference(withPath: "ShopReview")
    let userRef = Database.database().reference(withPath: "Users")
    let postsRef = Database.database().reference(withPath: "GenericPosts")
    var theUser = Auth.auth().currentUser
    var currentLocation: CLLocation!
    var locationManager = CLLocationManager()
    var data: Any = ""
    let searchText: String? = ""
    let user = Auth.auth().currentUser?.uid
    
    

    
    
    
    @IBOutlet weak var shopTableView: UITableView!

    
    //MARK: tap gesture recognizer
    @IBAction func tapHideKeyboard(_ sender: Any) {
       
    }
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            if sender.direction == .down {
                //shopSearchTextField.resignFirstResponder()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        postsRef.observe(.value, with: {
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
                self.posts = followingPosts
                self.shopTableView.reloadData()
            }
        })
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.shopTableView.delegate = self
        self.shopTableView.dataSource = self
        shopTableView.allowsSelection = true
       
        
        userRef.child("\(user!)").child("following").observe(.value, with: { (snapshot) in
        
            var userFollowing: [String] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    userFollowing.append(snapshot.key)
                }
            }
            self.following = userFollowing
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
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 376
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = shopTableView.cellForRow(at: indexPath) as? GenericPostTableViewCell

        guard let postID = cell?.postID else {return}
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
        
        let cell = shopTableView.dequeueReusableCell(withIdentifier: "GenericPostTVC", for: indexPath) as! GenericPostTableViewCell
        
        let post = posts[indexPath.row]
        
        
        
         let postID = post.postID
               let string = String(postID.prefix(2))
               switch string {
               case "sh":
                cell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.layer.borderWidth = 2
                cell.postAccentLine.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
               case "br":
                cell.layer.borderColor = #colorLiteral(red: 0.8148726821, green: 0.725468874, blue: 0.3972408772, alpha: 1)
                cell.layer.borderWidth = 2
                cell.postAccentLine.backgroundColor = #colorLiteral(red: 0.8148726821, green: 0.725468874, blue: 0.3972408772, alpha: 1)
               default:
                   print("Border Switch")
               }
     
        cell.setGenericCell(post: post)
        
        cell.toUserProfileTapHandler = {
            self.performSegue(withIdentifier: "toUserProfile", sender: post.userID)
            
        }
        
        let timeAgoString = Date().timeSincePost(post: post)
        cell.timeLabel.text =  timeAgoString
        
  
        
        return cell
    }
}







extension NearbyFeedViewController: UITextFieldDelegate {
    //UITextFieldDelegate(2) 1)- this is the function called when you hit the enter/retur/done button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        
        //shopSearchTextField.resignFirstResponder()
        return true
    }
    //2) this function runs when the text field returns true after it is no longer the first responder
    func textFieldDidEndEditing(_ textField: UITextField)  {
        
        
    }
    
    
}


  
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }
    
    
    
    
//    @IBAction func shopSearchButton(_ sender: Any) {
//
//        guard let searchText = searchText
//            //shopSearchTextField.text
//            else {
//
//            return
//        }
//        if CLLocationManager.locationServicesEnabled() {
//
//            currentLocation = locationManager.location
//            let latitude = currentLocation.coordinate.latitude
//            let longitude = currentLocation.coordinate.longitude
//            let theEndPoint = "https://api.yelp.com/v3/businesses/search?term=coffee shop&latitude=37.786882&longitude=-122.399972"
//
//        APIClient.shared.GET(endpoint: theEndPoint){ result in
//            switch result {
//            case .success(let json):
//                DispatchQueue.main.async {
//                    self.data = json
//                    print(json)
//
//
//                }
//            case .failure:
//                break
//            }
//
//        }
//    }
//    }

//        if shops.count == 0 {
//            return
//        } else {
//            func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//                guard let theCurrentLocation: CLLocationCoordinate2D = manager.location?.coordinate, let mostCurrentLocation = locations.last else {
//                    return
//                }
//                 let theEndPoint = "term=\(shopSearchTextField.text)&latitude=\(theCurrentLocation.latitude)&longitude=\(theCurrentLocation.longitude)"
//
//                APIClient.shared.GET(endpoint: theEndPoint){ result in
//                    switch result {
//                    case .success(let json):
//                        DispatchQueue.main.async {
//                            self.data = json
//                            print(json)
//                        }
//                    case .failure:
//                        break
//                    }
//                }
//        }
//    }
    
