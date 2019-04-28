//
//  VisitReviewViewController.swift
//  MoJoe
//
//  Created by Daniel Grant on 1/27/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//



import UIKit
import Firebase


class VisitReviewViewController: UIViewController {
    
    var user = Auth.auth().currentUser
     let ref = Database.database().reference(withPath: "BrewDebut")
    //This is the date for sorting through the posts. I could change the format to put it on the post though.
    var date: String {
        get {
            let postDate = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "YYYY-MM-dd HH:mm:ss"
            let stringDate = dateFormat.string(from: postDate)
            return stringDate
        }
    }
    
    
    @IBOutlet weak var reviewTableView: UITableView!
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction private func postButtonPress(_ sender: Any) {
        
        guard let brewCell: CMBCell = self.reviewTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CMBCell,
            let roastCell: CMRoastCell = self.reviewTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? CMRoastCell,
            let ratingCell: CMRatingCell = self.reviewTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? CMRatingCell,
            let reviewCell: CMRCell = self.reviewTableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? CMRCell
            
            else { print("no cell")
                return
        }
        //let lastTapped = brewCollectionView.indexPath(for: lastItem)
        guard let brew = brewCell.lastSelectedItem as? BrewTypeCVCell,
            let roast = roastCell.lastSelectedItem as? RoastTypeCVCell,
            let rating = ratingCell.ratingLabel.text,
            let review = reviewCell.reviewTextField.text,
            let user = user?.email
        
        
        
            else {print("error")
                return }
        
        let debut = BrewDebut(brew: brew.brewName.text!, roast: roast.roastLabel.text!, rating: Int(rating)!, review: review, user: user, date: date)
        
        let brewDebutRef = self.ref.child(review)
        brewDebutRef.setValue(debut.makeDictionary())
        
        
        
        
        
        self.dismiss(animated: true, completion: nil)
    }
    

   
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
 
    
        
    }
    
    



}

extension VisitReviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func borderSet(cell: UITableViewCell, color: UIColor, width: Int) {
        cell.layer.borderColor = color.cgColor
        cell.layer.borderWidth = CGFloat(width)
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 150
        case 1:
            return 150
        case 2:
            return 120
        case 3:
            return 120
      case 4:
            return 106
        default:
            return 60
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //THIS WHOLE THING BELOW CAN BE AN ENUM WHICH MIGHT LOOK A LITTLE CLEANER
      if indexPath.row == 0 {
            let brewCell = reviewTableView.dequeueReusableCell(withIdentifier: "CMBCell") as! CMBCell
           
            borderSet(cell: brewCell, color: .darkGray, width: 1)
          
            
            return brewCell
            
        } else if indexPath.row == 1 {
            let roastCell = reviewTableView.dequeueReusableCell(withIdentifier: "CMRoastCell") as! CMRoastCell
            
            borderSet(cell: roastCell, color: .darkGray, width: 1)
           
            return roastCell
            
            
        } else if indexPath.row == 2 {
            let locationCell = reviewTableView.dequeueReusableCell(withIdentifier: "CMLCell") as! CMLCell
            
            borderSet(cell: locationCell, color: .darkGray, width: 1)
           
            return locationCell
        
        } else if indexPath.row == 3 {
            let ratingCell = reviewTableView.dequeueReusableCell(withIdentifier: "CMRatingCell") as! CMRatingCell
            
            borderSet(cell: ratingCell, color: .darkGray, width: 1)
          
            
            return ratingCell
            
            
        }
      else if  indexPath.row == 4 {
        let cell = reviewTableView.dequeueReusableCell(withIdentifier: "CMRCell") as! CMRCell
        
        borderSet(cell: cell, color: .darkGray, width: 1)
        
        return cell
        }
        let cell = reviewTableView.dequeueReusableCell(withIdentifier: "CMRCell") as! CMRCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}



