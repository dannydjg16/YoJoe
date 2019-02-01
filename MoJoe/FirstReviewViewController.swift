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


class FirstReviewViewController: UIViewController {

    var imagePicker: UIImagePickerController!
    var reviewHelpers: [ReviewHelper] = []
    
    @IBOutlet weak var coffeePicOne: UIImageView!
    @IBOutlet weak var reviewHelperTableView: UITableView!
    
    
    //These are for making sure that the app still works and where they were when i can test it with my phone becuase i need the phone. also moved the protocols down to the extension
//    @IBAction func pictureButton(_ sender: Any) {
//        imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = .camera
//        self.present(imagePicker, animated: true, completion: nil)
//    }
    
    //One thing that i think will be less of a problem than thought is the image being in the post, i think its just blank until you add an image that you can see.
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //        imagePicker.dismiss(animated: true, completion: nil)
    //        coffeePicOne.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    //    }
    
    @IBAction private func postButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeInitialArray() -> [ReviewHelper] {
        var tempReviewHelp: [ReviewHelper] = []
        
        let reviewHelperBrew = ReviewHelper(reviewImage: #imageLiteral(resourceName: "first"), reviewCategory: "Add Type of Brew")
        
        let reviewHelperRoast = ReviewHelper(reviewImage: #imageLiteral(resourceName: "first"), reviewCategory: "Add Type of Roast")
        
        let reviewHelperRating = ReviewHelper(reviewImage: #imageLiteral(resourceName: "first"), reviewCategory: "Add Rating")
        
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
        cell.layer.borderWidth = 2
        
        return cell
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
