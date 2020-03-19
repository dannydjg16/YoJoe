//
//  CommentsForBrewDebut.swift
//  Alamofire
//
//  Created by Daniel Grant on 9/29/19.
//

import UIKit
import Firebase

class CommentsForBrewDebut: UIViewController {

    
    let ref = Database.database().reference(withPath: "BrewDebut")
    let commentRef = Database.database().reference(withPath: "Comments")
    var userRef = Database.database().reference(withPath: "Users")
    var postIDFromFeed: String = ""
    var brewImageURL: String = ""
    var allComments: [Comment] = []
    
    @IBOutlet weak var brewDebutCommentsTableView: UITableView!
    
    
    
    //MARK: post labels and images
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBAction func leaveComment(_ sender: Any) {
        
        let stringIndexOfPostID = postIDFromFeed.prefix(29)
        let stringPostID = String(stringIndexOfPostID)
        
        guard let comment = commentTextField.text else {
            return
        }
        
        if commentTextField.text == "" {
            return
        } else {
            let postComment = Comment(comment: comment, date: date, likesAmount: 0)
            
            let commentLocation = commentRef.child("BrewDebutComments").child("\(stringPostID)").child("\(randomString(length: 20))")
            
            commentLocation.setValue(postComment.makeDictionary())
            
            self.ref.child("\(stringPostID)").child("comments").observeSingleEvent(of: .value, with: { (snapshot) in
                guard let numberOfComments = snapshot.value as? Int
                    else {
                        return
                }
                self.ref.child("\(stringPostID)").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let brewDebut = BrewDebut(snapshot: snapshot) {
                        self.ref.child("\(stringPostID)").updateChildValues(["comments": numberOfComments + 1])
                    }
                })
            })
            commentTextField.text = ""
        }
        
    }
    
    
    
    var date: String {
        get {
            let postDate = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "YYYY-MM-dd HH:mm:ss"
            let stringDate = dateFormat.string(from: postDate)
            return stringDate
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        brewDebutCommentsTableView.delegate = self
//        brewDebutCommentsTableView.dataSource = self
        
        let endOfPostID = postIDFromFeed.suffix(10)
        let endString = String(endOfPostID)
        if endString == "addComment" {
            commentTextField.becomeFirstResponder()
        }
        
        let stringIndexOfPost = postIDFromFeed.prefix(29)
        let stringPostID = String(stringIndexOfPost)
        
        //find the post
        self.ref.child("\(stringPostID)").observe(.value, with: { (dataSnapshot) in
            
            guard let postInfo = dataSnapshot as? DataSnapshot else {
                return
            }
            if let brewDebut = BrewDebut(snapshot: postInfo){
                //MARK: set the post view on comments page
               
                self.brewImageURL = brewDebut.imageURL
                self.userRef.child("\(brewDebut.user)").child("UserPhoto").observeSingleEvent(of: .value, with: { (dataSnapshot) in
                    
                    guard let currentProfilePicture = dataSnapshot.value as? String else {
                        return
                    }
                    
                    
                    let ref = Storage.storage().reference(forURL: currentProfilePicture)
                    
                    
                    
                    
                    //MARK: set the labels and imageview
                    self.profilePicture.setImage(from: currentProfilePicture)
                    self.userLabel.text = brewDebut.user
                })
                
                if brewDebut.comments == 0 {
                    print("no comments")
                } else {
                    self.commentRef.child("BrewDebutComments").child("\(brewDebut.postID)").observe(.value
                        , with: { (snapshot) in
                            var newComments: [Comment] = []
                            
                            for child in snapshot.children {
                                if let snapshot = child as? DataSnapshot, let comment = Comment(snapshot: snapshot) {
                                    newComments.append(comment)
                                    self.allComments = newComments
                                    self.brewDebutCommentsTableView.reloadData()
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



extension CommentsForBrewDebut: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if allComments.count == 0 {
           
            let errorCell = brewDebutCommentsTableView.dequeueReusableCell(withIdentifier: "CommentErrorCell")
            
            return errorCell!
        }
        
        else {
            
            
            switch indexPath.row {
            case 0:
                let imageCell = brewDebutCommentsTableView.dequeueReusableCell(withIdentifier: "BrewImageCell") as! BrewCommentsImageCell
                imageCell.brewImage.setImage(from: self.brewImageURL)
            
            default:
                let comment = allComments[indexPath.row - 1]
                let cell = brewDebutCommentsTableView.dequeueReusableCell(withIdentifier: "BrewDebutCommentCell") as! BrewDebutCommentCell
                
                cell.setCommentCell(comment: comment)
                
                return cell
            }
            
            
            let comment = allComments[indexPath.row]
            let cell = brewDebutCommentsTableView.dequeueReusableCell(withIdentifier: "BrewDebutCommentCell") as! BrewDebutCommentCell
            
            cell.setCommentCell(comment: comment)
            
            return cell
        }
    }
    
    
}
