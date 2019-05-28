//
//  BrewDebutCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 4/26/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class BrewDebutCell: UITableViewCell {
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var brewLabel: UILabel!
    @IBOutlet weak var roastLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
   
    @IBOutlet weak var brewPicture: UIImageView!
    @IBOutlet weak var roastPicture: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    
    
    @IBAction func exampleBUtton(_ sender: Any) {
        print("clicked")
    }
    
    

    
    func setDebutCell(debut: BrewDebut){
        
        userLabel.text = "\(debut.user) brewed..."
        brewLabel.text = debut.brew
        roastLabel.text = debut.roast
        ratingLabel.text = "\(String(debut.rating)) / 10!"
        reviewLabel.text = debut.review
        dateLabel.text = debut.date
        profilePic.image = #imageLiteral(resourceName: "user")
        brewPicture.image = #imageLiteral(resourceName: "Espresso")
        roastPicture.image = #imageLiteral(resourceName: "coffee-beans")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
