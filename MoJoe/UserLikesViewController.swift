//
//  UserLikesViewController.swift
//  MoJoe
//
//  Created by Daniel Grant on 3/24/20.
//  Copyright © 2020 Daniel Grant. All rights reserved.
//

import UIKit
import Firebase

class UserLikesViewController: UIViewController {

    
    @IBOutlet weak var userLikesTableView: UITableView!
    
    var posts: [UserGenericPost] = []
    var postStrings: [String] = []
    let uid = Auth.auth().currentUser?.uid
    
    let userRef = Database.database().reference(withPath: "Users")
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //This is putting all of the users likes into the array. from here im gonna iterate through and check the 
        userRef.child("\(uid!)").child("likedPosts").observe(.value, with: {
            (snapshot) in
            
            guard let postID = snapshot.value as? String else {
                return
            }
            self.postStrings.append(postID)
        })
        
        
    }
    


}

extension UserLikesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = userLikesTableView.dequeueReusableCell(withIdentifier: "likedPostTableViewCell", for: indexPath) as! likedPostTableViewCell
        
        
        
        
        return cell
    }
    
    
    
    
    
    
}
