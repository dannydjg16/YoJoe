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
    var brewDebuts: [BrewDebut] = []
    //Not gonna put date here yet. it is already stored in the database, gonna see if i can just use this stored value rather than paste the whole thing in again.
    let brewDebutRef = Database.database().reference(withPath: "BrewDebut")
    
    @IBOutlet weak var brewDebutTable: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    
}


extension DebutYourBrew: UITableViewDelegate, UITableViewDataSource {

    func borderSet(cell: UITableViewCell, color: UIColor, width: Int) {
        cell.layer.borderColor = color.cgColor
        cell.layer.borderWidth = CGFloat(width)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        return 259
        
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brewDebuts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let debut = brewDebuts[indexPath.row]
        
        let debutCell = brewDebutTable.dequeueReusableCell(withIdentifier: "BrewDebutCell") as! BrewDebutCell
        //set the shit that goes with the cell. like the labels and all that shit. could be done right here or with a function that is created in the cell file.
        debutCell.setDebutCell(debut: debut)
        borderSet(cell: debutCell, color: .darkGray, width: 2)
        
        
        return debutCell
    }
}

