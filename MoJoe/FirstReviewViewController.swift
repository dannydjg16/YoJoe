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
    //the function to save the data of each vc so that it can be used in the cell. sent through a segue(prepare for segue). idek if what i said before this is true. set a breakpoint on any of them and see that the code is run before the vc is presented, not after it is dismissed. thinking of maybe implemetnign anoteher switch statement like the one that decides which segue to run when whatever cell is selected.
    
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
    
   
    

    var imagePicker: UIImagePickerController!
    var reviewHelpers: [ReviewHelper] = []
    
    @IBOutlet weak var coffeePicOne: UIImageView!
    @IBOutlet weak var reviewHelperTableView: UITableView!
    
    
   
    
    
    
    @IBAction private func postButtonPressed(_ sender: Any) {
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
        
        cell.layer.borderColor = UIColor.gray.cgColor
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



