//
//  ShopsFeedView.swift
//  MoJoe
//
//  Created by Daniel Grant on 4/23/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit
import Firebase

class ShopsFeedView: UIViewController {

    var userMe = Auth.auth().currentUser
    
    var shopReviews: [ShopReivew] = []
    
    let shopReviewRef = Database.database().reference(withPath: "ShopReview")
    let userRef = Database.database().reference(withPath: "Users")
    
    @IBOutlet weak var shopReviewTable: UITableView!
    
    var toReviewPage = UIButton()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSRCommentsPage",
            let commentsPage = segue.destination as? CommentsForShopReview {
            
            commentsPage.postIDFromFeed = sender as! String
          
        } else if segue.identifier == "toOtherUserProfile", let profilePage = segue.destination as? OtherUserProfilePage {
            profilePage.userID = sender as! String
        } else if segue.identifier == "toShopReviewSegue", let visitReview = segue.destination as? ShopReviewSheet {
            visitReview.typeOfPicture = sender as! String
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //MARK: Review page button stuff
        self.toReviewPage = UIButton(type: .custom)
        self.toReviewPage.setTitleColor(#colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1), for: .normal)
        self.toReviewPage.addTarget(self, action: #selector(displayReviewPage), for: .touchUpInside)
        self.view.addSubview(toReviewPage)
    
        shopReviewRef.queryOrdered(byChild: "date").observe(.value, with: {
            (snapshot) in
            
            var newShopReviews: [ShopReivew] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let shopReview = ShopReivew(snapshot: snapshot) {
                    newShopReviews.append(shopReview)
                }
            }
            self.shopReviews = newShopReviews.reversed()
            self.shopReviewTable.reloadData()
    })
    }
    
    @objc func displayReviewPage(){
        

        let pictureFinder = UIAlertController(title: "Create New Post", message: "Review a Shop!" , preferredStyle: .actionSheet)

        let cancelPost = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let takeAPicture = UIAlertAction(title: "Take a Picture", style: .default, handler: { action in
            
            self.performSegue(withIdentifier: "toShopReviewSegue", sender: "camera")
            
        })

        let chooseAPicture = UIAlertAction(title: "Choose Picture ", style: .default, handler: { action in
            

            self.performSegue(withIdentifier: "toShopReviewSegue", sender: "photoAlbum")
        })
        pictureFinder.addAction(cancelPost)
        pictureFinder.addAction(takeAPicture)
        pictureFinder.addAction(chooseAPicture)

        self.present(pictureFinder, animated: true, completion: nil)

    }
    
    //MARK: More button Stuff
    override func viewWillLayoutSubviews() {
        toReviewPage.layer.cornerRadius = toReviewPage.layer.frame.size.width / 2
        toReviewPage.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        toReviewPage.clipsToBounds = true
        toReviewPage.setImage(#imageLiteral(resourceName: "photo-camera"), for: .normal)
        toReviewPage.layer.borderWidth = 1
        toReviewPage.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
       
        toReviewPage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([toReviewPage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -14),toReviewPage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100.0), toReviewPage.widthAnchor.constraint(equalToConstant: 50), toReviewPage.heightAnchor.constraint(equalToConstant: 50)])
        
    }
    
   
}


extension ShopsFeedView: UITableViewDataSource, UITableViewDelegate {
    
    func borderSet(cell: UITableViewCell, color: UIColor, width: Int) {
        cell.layer.borderColor = color.cgColor
        cell.layer.borderWidth = CGFloat(width)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 586
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return shopReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let shop = shopReviews[indexPath.row]
        
        let shopCell =  shopReviewTable.dequeueReusableCell(withIdentifier: "ShopReviewCell") as! ShopReviewCell
        
        shopCell.setShopReviewCell(review: shop)
        
        let uid = shop.user
        
        self.userRef.child(uid).child("UserName").observeSingleEvent(of: .value, with: { (dataSnapshot) in
            
            guard let currentUserName = dataSnapshot.value as? String else { return }
            shopCell.userVisitedButton.setTitle("\(currentUserName) visited...", for: .normal)   
            
        })
        
        
        self.userRef.child(uid).child("UserPhoto").observeSingleEvent(of: .value, with: { (dataSnapshot) in
            
            guard let currentProfilePicture = dataSnapshot.value as? String else { return
                
            }
       
            shopCell.profilePic.setImage(from: currentProfilePicture)
          
            
        })

        
 
     
        let timeAgoString = Date().timeSinceShopReview(theShop: shop)
        
        shopCell.timeSinceLabel.text =  timeAgoString
        
        

       
       
        
        
        borderSet(cell: shopCell, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), width: 2)
        
        shopCell.tapHandler = {
            self.performSegue(withIdentifier: "toSRCommentsPage", sender: shopCell.postID + "addComment")
    }
        shopCell.toUserProfileTapHandler = {
            self.performSegue(withIdentifier: "toOtherUserProfile", sender: shop.user)
            
        }
        
        
        
        return shopCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = shopReviewTable.cellForRow(at: indexPath) as? ShopReviewCell
        
        let cellPostID = cell?.postID
        
        performSegue(withIdentifier: "toSRCommentsPage", sender: cellPostID)
    }
    
   
    
    
}


