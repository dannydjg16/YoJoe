//
//  CommentsForShopReview.swift
//  MoJoe
//
//  Created by Daniel Grant on 8/6/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit
import Firebase


class CommentsForShopReview: UIViewController {
    
    let ref = Database.database().reference(withPath: "ShopReview")
    var userRef = Database.database().reference(withPath: "Users")
    
    //MARK: Post Vars
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var shopLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var coffeeTypeLabel: UILabel!
    
    
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBAction func hideKeyboard(_ sender: Any) {
        self.commentTextField.resignFirstResponder()
    }
    
    @IBAction func addComment(_ sender: Any) {
       
        let stringIndexOfPostID = postIDFromFeed.prefix(30)
        let stringPostID = String(stringIndexOfPostID)
        
        if commentTextField.text != nil {
        
        let commentLocation = ref.child("\(stringPostID)").child("Comments")
        commentLocation.setValue(["\(randomString(length: 20))": commentTextField.text])
        
        commentTextField.text = ""
        }
    }
   
    var postIDFromFeed: String = ""
    
    var postRef = Database.database().reference(withPath: "ShopReview")
    
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        self.postIDFromFeed = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        
        
        //Based on if the cell or comment button is pressed, what the first responder is when view loads.

        
        let endOfPostID = postIDFromFeed.suffix(10)
        let endString = String(endOfPostID)
        if endString == "addComment" {
            commentTextField.becomeFirstResponder()
        }
        
        
        //MARK: Making the Post View
        let stringIndexOfPostID = postIDFromFeed.prefix(30)
        let stringPostID = String(stringIndexOfPostID)
        
        
        self.postRef.child("\(stringPostID)").observe(.value, with: { (dataSnapshot) in
            
            guard let postInfo = dataSnapshot as? DataSnapshot else {
                return
            }
            if let shopReview = ShopReivew(snapshot: postInfo){
                
                self.userRef.child("\(shopReview.user)").child("UserPhoto").observeSingleEvent(of: .value, with: {(dataSnapshot) in
                    
                    guard let currentProfilePicture = dataSnapshot.value as? String else { return }
                    //Actually setting the "views" variables
                    self.profilePic.setImage(from: currentProfilePicture)
                    self.nameLabel.text = shopReview.user
                    self.shopLabel.text = shopReview.shop
                    self.ratingLabel.text = String(shopReview.rating) + "/10"
                    self.coffeeTypeLabel.text = shopReview.coffeeType
                    
                    
                    
                })
                
                //self.profilePic.image = shopre
//                cell.setShopReviewCommentCell(review: shopReview)
                //Now i need to do this^ but for a view. i still think Im gonna make a function but idk if id need to make a class first, that is where setshopreviewcell is from. 
            }
            
        })
        
        
       
        
        
        
        let bar = UIToolbar()
        let reset = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: nil)
        bar.items = [reset]
        bar.sizeToFit()
        commentTextField.inputAccessoryView = bar
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeHandler))
        downSwipe.direction = .down
        self.view.addGestureRecognizer(downSwipe)
        
    }
    
    @objc func swipeHandler(gesture: UISwipeGestureRecognizer){
        switch gesture.direction {
        case .down :
            commentTextField.resignFirstResponder()
        default:
            break
        }
    }
    

   
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}


extension CommentsForShopReview: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "PostComment") as! PostComment
        
        cell.comment.text = ":)"
        cell.commentBubble.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.commentBubble.layer.borderWidth = 1
        
        //If addComment was added to the postID by a press of the comment button instead of cell selected, it gets taken away here.
        
        let stringIndexOfPostID = postIDFromFeed.prefix(30)
        let stringPostID = String(stringIndexOfPostID)
        
        
       
        

        
        
        
       
        
        
        
        return cell
      
    }


}
