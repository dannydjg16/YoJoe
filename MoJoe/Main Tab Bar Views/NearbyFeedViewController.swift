//
//  NearbyFeedViewController.swift
//  MoJoe
//
//  Created by Daniel Grant on 11/11/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import UIKit
import Firebase

class NearbyFeedViewController: UIViewController {

    var posts: [Review] = []
    var user: User? {
    var ref: DatabaseReference!
        
        
        guard let firebaseUser = Auth.auth().currentUser,
            let email = firebaseUser.email else {
            return nil
        }

        return User(uid: firebaseUser.uid, email: email)
    }
    
    let ref = Database.database().reference(withPath: "Reviews")
    
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

   
     ref.observe(.value, with: { snapshot in
       
        var newReviews: [Review] = []
        
        for child in snapshot.children {
            if let snapshot = child as? DataSnapshot,
                let review = Review(snapshot: snapshot){
                newReviews.append(review)
            }
        }
        self.posts = newReviews
        self.tableView.reloadData()
     })
    }

    @IBAction func sendMessage(_ sender: Any) {
        guard let message = messageField.text,
            let user = self.user else {
            return
        }
        
        let review = Review(description: message, reviewer: user.email)
       
        let reviewRef = self.ref.child(message)
        
        reviewRef.setValue(review.toDictionary())
    }
}

extension NearbyFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reviewCell = tableView.dequeueReusableCell(withIdentifier: "Review Cell", for: indexPath)
        let review = posts[indexPath.row]
        
        reviewCell.textLabel?.text = review.description
        reviewCell.detailTextLabel?.text = review.reviewer
        
        return reviewCell
    }
}

extension NearbyFeedViewController: UITextFieldDelegate {
    
}
