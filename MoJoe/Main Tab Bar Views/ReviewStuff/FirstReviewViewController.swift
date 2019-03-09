//
//  FirstReviewViewController.swift
//  MoJoe
//
//  Created by Daniel Grant on 11/23/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//



//This is going to be the view for posting what type of coffee the user made themself and wants to share

import UIKit
import Firebase

class FirstReviewViewController: UIViewController, ChangeCellTextDelegate, ChangeCellIntDelegate {
    
    
    var user: User? {
    var ref: DatabaseReference!
        guard let firebaseUser = Auth.auth().currentUser,
            let email = firebaseUser.email else {
                return nil
        }
        return User(uid: firebaseUser.uid, email: email)
    }
    
    var userMe = Auth.auth().currentUser
    
    @IBOutlet weak var detailTextField: UITextField!
    
    var imagePicker: UIImagePickerController!
    var reviewHelpers: [ReviewHelper] = []
    
    @IBOutlet weak var coffeePicOne: UIImageView!
    @IBOutlet weak var reviewHelperTableView: UITableView!
   
    let ref = Database.database().reference(withPath: "ReviewPosts")
    var date: String {
        get {
            let postDate = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "YYYY-MM-dd HH:mm:ss"
            let stringDate = dateFormat.string(from: postDate)
            return stringDate
        }
    }
    
    
    
    
    
    
    //MARK: These are the functions that change the value of the cells text to whatever the person picked for the roast, brew, and rating.
    //this is the function to change the third(rating) cell to whatever the rating will be. this is easy to see because of the INT in the name and row:2.
    func changeCellInt(number: Int) {
        let indexPath = IndexPath.init(row: 2, section: 0)
        let cell = reviewHelperTableView.cellForRow(at: indexPath) as! ReviewHelperTableViewCell
        cell.reviewCategory.text = String(number)
    }
    
    
    //this is the function to change what is in the first cell of the tableview. check row:0, section:0 to know. Tbh mad happy i did this. i used indexpathforselectedrow so that the code could realize what cell i wanted to alter. then instead of using a preset row for the indexpath to change, i just used that constant
    func changeCellText(text: String) {
        let cellOfClick = reviewHelperTableView.indexPathForSelectedRow?.row
        let indexPath = IndexPath.init(row:cellOfClick!, section: 0)
        let cell = reviewHelperTableView.cellForRow(at: indexPath) as! ReviewHelperTableViewCell
        cell.reviewCategory.text = text
    }
    
    
    //MARK: the function that helps with throwing data between the review vc and the modally presented view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController, let brewPick = nav.topViewController as? BrewPickViewController {
            brewPick.cellDelegate = self
        }
        if let nav1 = segue.destination as? UINavigationController, let roastPick = nav1.topViewController as? RoastPickViewController {
            roastPick.roastDelegate = self
        }
        if let nav2 = segue.destination as? UINavigationController, let ratePick = nav2.topViewController as? RatingPickViewController {
            ratePick.ratingDelegate = self
        }
        
    }
   
    @IBAction private func postButtonPressed(_ sender: Any) {
        
        guard let detail = detailTextField.text,
            let brewCell: ReviewHelperTableViewCell = self.reviewHelperTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! ReviewHelperTableViewCell,
            let roastCell: ReviewHelperTableViewCell = self.reviewHelperTableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! ReviewHelperTableViewCell,
            let ratingCell: ReviewHelperTableViewCell = self.reviewHelperTableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! ReviewHelperTableViewCell else {
            return
        }
        //MARK: These are the errors that could happen as a result of filling in the review incorecctly or just not filling it in at all.
        
        //This shit is here in case i want to contnu
//        guard let detailError = detailTextField.text, let brewError = brewCell.reviewCategory.text, let roastError = roastCell.reviewCategory.text, let ratingError = ratingCell.reviewCategory.text else {
//
//
//            return
//        }
        
        
//    guard let detailOfPost = detail, let poster = self.user, let brewType = brewCell.reviewCategory.text, let roastType = roastCell.reviewCategory.text, let
        
        
        if let rating = Int(ratingCell.reviewCategory.text!) {
       
            
            
            
            
            let reviewPost = ReviewPost(detail: detail, poster: (self.userMe?.displayName)!, brew: brewCell.reviewCategory.text!, roast: roastCell.reviewCategory.text!, rating: rating, date: date)
            
            let reviewRef = self.ref.child(detail)
            reviewRef.setValue(reviewPost.makeDictionary())
            
            
            
        print(reviewPost.brew)
        print(reviewPost.rating)
        print(reviewPost.roast)
        print(reviewPost.detail)
        
        } else if ratingCell.reviewCategory.text == "Add Rating" || brewCell.reviewCategory.text == "Add Type of Brew" || roastCell.reviewCategory.text == "Add Type of Roast" {
            reviewErrorAlert(title: "One or More Sections Not Filled Out", message: "Finish Review")
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
      
        //ELSE JUST PRESENT A ALERT THAT SAYS YOU NEED TO FILL OUT THE RATING FIELD.
        
        
      self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func makeInitialArray() -> [ReviewHelper] {
        var tempReviewHelp: [ReviewHelper] = []
        
        let reviewHelperBrew = ReviewHelper(reviewImage: #imageLiteral(resourceName: "coffeeCup"), reviewCategory: "Add Type of Brew")
        
        let reviewHelperRoast = ReviewHelper(reviewImage: #imageLiteral(resourceName: "coffeeCup"), reviewCategory: "Add Type of Roast")
        
        let reviewHelperRating = ReviewHelper(reviewImage: #imageLiteral(resourceName: "coffeeCup"), reviewCategory: "Add Rating")
        
        tempReviewHelp.append(reviewHelperBrew)
        tempReviewHelp.append(reviewHelperRoast)
        tempReviewHelp.append(reviewHelperRating)
        
        return tempReviewHelp
    }
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewHelpers = makeInitialArray()
        
        reviewHelperTableView.delegate = self
        reviewHelperTableView.dataSource = self
        
        
        
        
        detailTextField.textAlignment = .left
        detailTextField.contentVerticalAlignment = .top

        
        navigationController?.navigationBar.barTintColor = .gray
    }
    


}


extension FirstReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewHelpers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let review = reviewHelpers[indexPath.row]
        
        
        let cell =
            reviewHelperTableView?.dequeueReusableCell(
                withIdentifier:
            "ReviewHelperTableViewCell")
            as!
        ReviewHelperTableViewCell
        
        cell.setReview(review: review)
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let currentReview = reviewHelpers[indexPath.row]
        
     
        print(indexPath.row)
        switch indexPath.row {
        case 0: self.performSegue(withIdentifier: "toBrewReview", sender: self)
        case 1:
            self.performSegue(withIdentifier: "toRoastReview", sender: self)
       
        case 2:
            self.performSegue(withIdentifier: "toRatingReview", sender: self)
        default:
            return
        }
        
      
    }
    
}



extension FirstReviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func pictureButton(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        coffeePicOne.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    }
    
}

//this extension was used when i didnt have segues helping guide the flow of the app. it may still be useful when i need it though. (that will be when i want to make the modal presentation only cover like 1/2 or 2/3 the underlying screen.
extension FirstReviewViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
       
        return smallViewInBigView(presentedViewController: presented, presenting: presenting)
    }
}


extension FirstReviewViewController {
    //MARK: function that will hold the alertaction to fill in the int field, or to change the roast/rating/whatever.
    func reviewErrorAlert(title: String, message: String) {
        let reviewError = UIAlertController(title: title, message: message, preferredStyle: .alert)
        reviewError.addAction(UIAlertAction(title: "Finish Review", style: .default, handler: nil))
        self.present(reviewError, animated: true, completion: nil)
    }
}
