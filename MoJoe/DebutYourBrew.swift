//
//  DebutYourBrew.swift
//  MoJoe
//
//  Created by Daniel Grant on 4/18/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit
import Firebase


class DebutYourBrew: UIViewController {

    var userMe = Auth.auth().currentUser
    var userDisplayName: String = ""
    var brewDebuts: [BrewDebut] = []
    //Not gonna put date here yet. it is already stored in the database, gonna see if i can just use this stored value rather than paste the whole thing in again.
    let brewDebutRef = Database.database().reference(withPath: "BrewDebut")
    let userRef = Database.database().reference(withPath: "Users")
    
    @IBOutlet weak var brewDebutTable: UITableView!
    
    
    var toReviewPage = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       
        
        self.toReviewPage = UIButton(type: .custom)
        self.toReviewPage.setTitleColor(#colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1), for: .normal)
        self.toReviewPage.addTarget(self, action: #selector(displayReviewPage), for: .touchUpInside)
        self.view.addSubview(toReviewPage)
        
        
        brewDebutRef.queryOrdered(byChild: "date").observe(.value, with: { (snapshot) in
            
            var newDebuts: [BrewDebut] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   
                    let brewDebut = BrewDebut(snapshot: snapshot){
                   
                    newDebuts.append(brewDebut)
                    
                    self.brewDebuts = newDebuts
                    self.brewDebutTable.reloadData()
                }
            }
            self.brewDebuts = newDebuts
            self.brewDebutTable.reloadData()
        })
    }
    
    @objc func displayReviewPage(){
        self.performSegue(withIdentifier: "toBrewDebutSegue", sender: self)
    }
    
    override func viewWillLayoutSubviews() {
        toReviewPage.layer.cornerRadius = toReviewPage.layer.frame.size.width / 2
        toReviewPage.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        toReviewPage.layer.borderWidth = 1
        toReviewPage.backgroundColor = #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1)
        toReviewPage.clipsToBounds = true
        toReviewPage.setImage(#imageLiteral(resourceName: "coffee-bean-for-a-coffee-break"), for: .normal)
        toReviewPage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([toReviewPage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -14),toReviewPage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100.0), toReviewPage.widthAnchor.constraint(equalToConstant: 50), toReviewPage.heightAnchor.constraint(equalToConstant: 50)])
        
    }

    
}


extension DebutYourBrew: UITableViewDelegate, UITableViewDataSource {

    func borderSet(cell: UITableViewCell, color: UIColor, width: Int) {
        cell.layer.borderColor = color.cgColor
        cell.layer.borderWidth = CGFloat(width)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        return 215
        
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brewDebuts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let debut = brewDebuts[indexPath.row]
        
        let debutCell = brewDebutTable.dequeueReusableCell(withIdentifier: "BrewDebutCell") as! BrewDebutCell
        
        switch debut.roast {
        case "Light Roast":
            borderSet(cell: debutCell, color: #colorLiteral(red: 1, green: 0.8202751079, blue: 0.3338571206, alpha: 1), width: 5)
        case "Medium Roast":
            borderSet(cell: debutCell, color: #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1), width: 5)
        case "Dark Roast":
            borderSet(cell: debutCell, color: #colorLiteral(red: 0.254897684, green: 0.1924804384, blue: 0.08138259897, alpha: 1), width: 5)
        default:
            debutCell.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        //set the shit that goes with the cell. like the labels and all that shit. could be done right here or with a function that is created in the cell file.
        debutCell.setDebutCell(debut: debut)
        
        let uid = debut.user
        
        self.userRef.child(uid).child("UserName").observeSingleEvent(of: .value, with: { (dataSnapshot) in
          
            guard let currentUserName = dataSnapshot.value as? String else { return }
            debutCell.userLabel.text = "\(currentUserName) brewed..."
            
        })
        
        
        self.userRef.child(uid).child("UserPhoto").observeSingleEvent(of: .value, with: {(dataSnapshot) in
            
            guard let currentProfilePicture = dataSnapshot.value as? String else { return }
            debutCell.profilePic.setImage(from: currentProfilePicture)
            
        })
        
        let timeAgoString = Date().timeSinceBrewDebut(debut: debut)
        
        debutCell.timeAgoLabel.text = timeAgoString
        
        
        return debutCell
    }
}


