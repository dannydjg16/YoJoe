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
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var beanLocationLabel: UILabel!
    
    @IBOutlet weak var brewPicture: UIImageView!
    @IBOutlet weak var roastPicture: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    
    
    @IBAction func exampleBUtton(_ sender: Any) {
        print("clicked")
    }
    
    

    
    func setDebutCell(debut: BrewDebut){
        
        
        brewLabel.text = debut.brew
        roastLabel.text = debut.roast
        ratingLabel.text = "\(String(debut.rating)) / 10!"
        reviewLabel.text = debut.review
        
        beanLocationLabel.text = debut.beanLocation
        
        switch debut.brew {
        case "French Press":
            self.brewPicture.image = #imageLiteral(resourceName: "Messages Image(3128922777)")
        case "Pour Over":
            self.brewPicture.image = #imageLiteral(resourceName: "POUROVER")
        case "Cold Brew":
            self.brewPicture.image = #imageLiteral(resourceName: "Cold Brew")
        case "Espresso":
            self.brewPicture.image = #imageLiteral(resourceName: "Espresso")
        case "Drip":
            self.brewPicture.image = #imageLiteral(resourceName: "Drip")
        default:
            self.brewPicture.image = #imageLiteral(resourceName: "star")
            
        }
        
        
        
        
       
        //roastPicture.image = #imageLiteral(resourceName: "coffee-beans")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
       self.profilePic.layer.cornerRadius = profilePic.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
