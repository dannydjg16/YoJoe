//
//  CMBCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 3/24/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class CMBCell: UITableViewCell {

    @IBOutlet weak var brewCollectionView: UICollectionView!
    var lastSelectedItem: UICollectionViewCell?
    var brewTypes: [ReviewHelper] = []
    
    
    func makeBrewTypes() -> [ReviewHelper] {
        var tempViewArray: [ReviewHelper] = []
        
        let frenchPress = ReviewHelper(reviewImage: #imageLiteral(resourceName: "Messages Image(3128922777)"), reviewCategory: "French Press")
        let pourOver = ReviewHelper(reviewImage: #imageLiteral(resourceName: "POUROVER"), reviewCategory: "Pour Over")
        let coldBrew = ReviewHelper(reviewImage: #imageLiteral(resourceName: "Cold Brew"), reviewCategory: "Cold Brew")
        let espresso = ReviewHelper(reviewImage: #imageLiteral(resourceName: "Espresso"), reviewCategory: "Espresso")
        let drip = ReviewHelper(reviewImage: #imageLiteral(resourceName: "Drip"), reviewCategory: "Drip")
        let other = ReviewHelper(reviewImage: #imageLiteral(resourceName: "coffee-beans"), reviewCategory: "Other")
        
        
        tempViewArray.append(frenchPress)
        tempViewArray.append(pourOver)
        tempViewArray.append(coldBrew)
        tempViewArray.append(espresso)
        tempViewArray.append(drip)
        tempViewArray.append(other)
        
        return tempViewArray
    }
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        brewTypes = makeBrewTypes()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
    }

}


extension CMBCell: UICollectionViewDataSource,  UICollectionViewDelegate {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let brew = brewTypes[indexPath.row]
        
        let brewTypeCell = brewCollectionView.dequeueReusableCell(withReuseIdentifier: "BrewTypeCVCell", for: indexPath) as! BrewTypeCVCell
        
        brewTypeCell.setCell(brew: brew)
        
        brewTypeCell.layer.borderColor = UIColor.darkGray.cgColor
        brewTypeCell.layer.borderWidth = 2
        
        return brewTypeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = brewCollectionView.cellForItem(at: indexPath) else { return }
        cell.backgroundColor = #colorLiteral(red: 0.812450707, green: 0.7277771831, blue: 0.3973348141, alpha: 1)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let theLastSelectedItem = brewCollectionView.cellForItem(at: indexPath)  else { return }
        theLastSelectedItem.backgroundColor = UIColor.brown
        lastSelectedItem = theLastSelectedItem
    }
    
}
