//
//  VisitReviewViewController.swift
//  MoJoe
//
//  Created by Daniel Grant on 1/27/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//



import UIKit



class VisitReviewViewController: UIViewController {
    
    
    @IBOutlet weak var reviewTableView: UITableView!
  
    
    
    @IBAction private func postButtonPress(_ sender: Any) {
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
            return 106
        case 1:
            return 150
        case 2:
            return 150
        case 3:
            return 120
      case 4:
            return 120
        default:
            return 60
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //THIS WHOLE THING BELOW CAN BE AN ENUM WHICH MIGHT LOOK A LITTLE CLEANER
        if indexPath.row == 0 {
            let cell = reviewTableView.dequeueReusableCell(withIdentifier: "CMRCell") as! CMRCell
            
            
            
            borderSet(cell: cell, color: .darkGray, width: 1)
            
            return cell
            
        } else if indexPath.row == 1 {
            let brewCell = reviewTableView.dequeueReusableCell(withIdentifier: "CMBCell") as! CMBCell
           
            borderSet(cell: brewCell, color: .darkGray, width: 1)
          
            
            return brewCell
            
        } else if indexPath.row == 2 {
            let roastCell = reviewTableView.dequeueReusableCell(withIdentifier: "CMRoastCell") as! CMRoastCell
            
            borderSet(cell: roastCell, color: .darkGray, width: 1)
           
            return roastCell
            
            
        } else if indexPath.row == 3 {
            let locationCell = reviewTableView.dequeueReusableCell(withIdentifier: "CMLCell") as! CMLCell
            
            borderSet(cell: locationCell, color: .darkGray, width: 1)
           
            return locationCell
        
        } else if indexPath.row == 4 {
            let ratingCell = reviewTableView.dequeueReusableCell(withIdentifier: "CMRatingCell") as! CMRatingCell
            
            borderSet(cell: ratingCell, color: .darkGray, width: 1)
          
            
            return ratingCell
            
            
        }
        let cell = reviewTableView.dequeueReusableCell(withIdentifier: "CMRCell") as! CMRCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}



