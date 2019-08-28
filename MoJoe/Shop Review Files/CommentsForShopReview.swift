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

    @IBOutlet weak var commentsTableView: UITableView!
    var postIDFromFeed: String = ""
    
    var postRef = Database.database().reference(withPath: "ShopReview")
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension CommentsForShopReview: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = commentsTableView.dequeueReusableCell(withIdentifier: "PostCellOnCommentsPage") as! PostCellOnCommentsPage
        
        self.postRef.child("\(postIDFromFeed)").observe(.value, with: { (dataSnapshot) in
            
            guard let postInfo = dataSnapshot as? DataSnapshot else {
                return
            }
            if let shopReview = ShopReivew(snapshot: postInfo){
                cell.setShopReviewCommentCell(review: shopReview)
            }
            
            })
        
//        switch indexPath.section {
//        case 0:
//            if indexPath.row == 0 {
//            let cell = commentsTableView.dequeueReusableCell(withIdentifier: "PostCellOnCommentsPage") as! PostCellOnCommentsPage
//
//            cell.postIDLabel.text = cell.postID
//
//            return cell
//            }
//
//        default:
//            let cell = commentsTableView.dequeueReusableCell(withIdentifier: "PostCellOnCommentsPage", for: IndexPath.init(row: 0, section: 0)) as! PostCellOnCommentsPage
//
//            cell.postIDLabel.text = cell.postID
//            return cell
//        }
//        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "PostCellOnCommentsPage") as! PostCellOnCommentsPage
//
//        cell.postIDLabel.text = cell.postID
//
//        return cell
        
        
        
       
        
        
        
        return cell
      
    }


}
