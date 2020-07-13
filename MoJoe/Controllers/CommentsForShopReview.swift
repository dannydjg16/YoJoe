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
    
    //MARK: Constants/Vars
    private let ref = Database.database().reference(withPath: "ShopReview")
    private let commentRef = Database.database().reference(withPath: "Comments")
    private var userRef = Database.database().reference(withPath: "Users")
    var postIDFromFeed: String = ""
    private var allComments: [Comment] = []
    
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
    @IBOutlet private weak var profilePic: UIImageView!
    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var timeSinceLabel: UILabel!
    @IBOutlet private weak var shopLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var coffeeTypeLabel: UILabel!
    @IBOutlet private weak var postExplanation: UILabel!
    @IBOutlet private weak var postViewOnCommentsPage: UIView!
    @IBOutlet private weak var commentsTableView: UITableView!
    @IBOutlet private weak var commentTextField: UITextField!
    
    @IBAction private func hideKeyboard(_ sender: Any) {
        self.commentTextField.resignFirstResponder()
    }
    
    @IBAction private func addComment(_ sender: Any) {
        
        let stringIndexOfPostID = postIDFromFeed.prefix(30)
        let stringPostID = String(stringIndexOfPostID)
        
        guard let comment = commentTextField.text else {
            return
        }
        
        if commentTextField.text == "" {
            return
        } else {
            
            let postComment = Comment(comment: comment, date: date, likesAmount: 0)
            
            let commentLocation = commentRef.child("ShopReviewComments").child("\(stringPostID)").child("\(randomString(length: 20))")
            
            commentLocation.setValue(postComment.makeDictionary())
            
            
            self.ref.child("\(stringPostID)").child("comments").observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let numberOfComments = snapshot.value as? Int else {
                    return
                }
                self.ref.child("\(stringPostID)").observeSingleEvent(of: .value, with: {
                    (snapshot) in
                    
                        self.ref.child("\(stringPostID)").updateChildValues(["comments": numberOfComments + 1])
                })
            })
            commentTextField.text = ""
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        self.postIDFromFeed = "viewDidDissapear comments for shop review"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tapGestureOnPicture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        postImageView.addGestureRecognizer(tapGestureOnPicture)
        postImageView.isUserInteractionEnabled = true
        postImageView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        postImageView.layer.borderWidth = 1
        postImageView.contentMode = .scaleAspectFill
        
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        commentTextField.delegate = self
        commentTextField.layer.borderWidth = 1
        commentTextField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        postViewOnCommentsPage.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        postViewOnCommentsPage.layer.borderWidth = 2
        
        commentsTableView.layer.borderWidth = 2
        commentsTableView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        profilePic.layer.cornerRadius = profilePic.frame.height / 2
        profilePic.layer.borderWidth = 0.5
        profilePic.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        profilePic.contentMode = .scaleAspectFill
        
        
        
        //Based on if the cell or comment button is pressed, what the first responder is when view loads.
        let endOfPostID = postIDFromFeed.suffix(10)
        let endString = String(endOfPostID)
        if endString == "addComment" {
            commentTextField.becomeFirstResponder()
        }
        
        //MARK: Making the Post View
        let stringIndexOfPostID = postIDFromFeed.prefix(30)
        let stringPostID = String(stringIndexOfPostID)
        
        self.ref.child("\(stringPostID)").observe(.value, with: { (dataSnapshot) in
            
            if let shopReview = ShopReivew(snapshot: dataSnapshot){
                
                //MARK: set the post view on comments page
                self.postImageView.setImage(from: shopReview.imageURL)
                
                self.postExplanation.text = shopReview.review
                
                let timeAgoString = Date().timeSincePostFromString(postDate: shopReview.date)
                self.timeSinceLabel.text = timeAgoString
                
                self.userRef.child("\(shopReview.user)").child("UserPhoto").observeSingleEvent(of: .value, with: { (dataSnapshot) in
                    
                    guard let currentProfilePicture = dataSnapshot.value as? String else { return }
                    //Actually setting the "views" variables
                    self.profilePic.setImage(from: currentProfilePicture)
                    
                    self.userRef.child(shopReview.user).child("UserName").observeSingleEvent(of: .value, with: { (dataSnapshot) in
                        
                        guard let currentUserName = dataSnapshot.value as? String else { return }
                        
                        self.nameLabel.text = currentUserName + " " + "visited..."
                    })
                    
                    self.shopLabel.text = shopReview.shop
                    self.ratingLabel.text = String(shopReview.rating) + "/10"
                    self.coffeeTypeLabel.text = shopReview.coffeeType
                })
                if shopReview.comments == 0 {
                    
                } else {
                    
                    self.commentRef.child("ShopReviewComments").child("\(shopReview.postID)").observe(.value, with: {
                        (snapshot) in
                        
                        var newComments: [Comment] = []
                        
                        for child in snapshot.children {
                            
                            if let snapshot = child as? DataSnapshot, let comment = Comment(snapshot: snapshot) {
                                
                                newComments.append(comment)
                                
                                self.allComments = newComments.sorted(by: {
                                    $0.date > $1.date
                                })
                                
                                self.commentsTableView.reloadData()
                            }
                        }
                    })
                }
            }
        })
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeHandler))
        downSwipe.direction = .down
        self.view.addGestureRecognizer(downSwipe)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc private func keyboardNotification(notification: NSNotification) {
        
        if self.view.frame.origin.y == -300 {
            self.view.frame.origin.y = 0
        } else {
            self.view.frame.origin.y = -300
        }
        
    }
    
    @objc private func swipeHandler(gesture: UISwipeGestureRecognizer) {
        
        switch gesture.direction {
        case .down :
            self.view.endEditing(true)
        default:
            break
        }
    }
    
    @objc private func tapHandler(sender: UITapGestureRecognizer){
        
        
        
    }
    
    private func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    
}


extension CommentsForShopReview: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if allComments.count == 0 {
            return 1
        } else {
            return allComments.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if allComments.count == 0 {
            return 193
        } else  {
            return 47
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if allComments.count == 0 {
            
            let errorCell = commentsTableView.dequeueReusableCell(withIdentifier: "LeaveAComment")
            
            return errorCell!
            
        } else {
            
            let comment = allComments[indexPath.row]
            
            let cell = commentsTableView.dequeueReusableCell(withIdentifier: "PostComment") as! PostComment
            
            cell.setCommentCell(comment: comment)
            
            
            cell.layer.borderWidth = 1
            cell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.layer.cornerRadius = cell.frame.height / 14
            
            return cell
        }
    }
    
    
}

extension CommentsForShopReview: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let stringIndexOfPostID = postIDFromFeed.prefix(30)
        let stringPostID = String(stringIndexOfPostID)
        
        guard let comment = commentTextField.text else {
            return true
        }
        
        if commentTextField.text == "" {
            return true
        } else {
            
            let postComment = Comment(comment: comment, date: date, likesAmount: 0)
            
            let commentLocation = commentRef.child("ShopReviewComments").child("\(stringPostID)").child("\(randomString(length: 20))")
            commentLocation.setValue(postComment.makeDictionary())
            
            self.ref.child("\(stringPostID)").child("comments").observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let numberOfComments = snapshot.value as? Int else {
                    return
                }
                
                        self.ref.child("\(stringPostID)").updateChildValues(["comments": numberOfComments + 1])
            })
            
            commentTextField.text = ""
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    
}
