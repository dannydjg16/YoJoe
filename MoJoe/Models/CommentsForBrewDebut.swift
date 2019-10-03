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
    let commentRef = Database.database().reference(withPath: "BrewDebutComments")
    var userRef = Database.database().reference(withPath: "Users")
    var postIDFromFeed: String = ""
    var allComments: [Comment] = []
    
    @IBOutlet weak var brewDebutCommentsTableView: UITableView!
    
    
    
    //MARK: post labels and images
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var brewImage: UIImageView!
    @IBOutlet weak var profilePicture: UIImageView!
    
    
    
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
print("danny")
        
    }
    

    

}
