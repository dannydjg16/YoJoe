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
        
        let frenchPress = ReviewHelper(reviewImage: #imageLiteral(resourceName: "search"), reviewCategory: "French Press")
        let pourOver = ReviewHelper(reviewImage: #imageLiteral(resourceName: "shop"), reviewCategory: "Pour Over")
        let coldBrew = ReviewHelper(reviewImage: #imageLiteral(resourceName: "star"), reviewCategory: "Cold Brew")
        let espresso = ReviewHelper(reviewImage: #imageLiteral(resourceName: "coffeeCup"), reviewCategory: "Espresso")
        let drip = ReviewHelper(reviewImage: #imageLiteral(resourceName: "coffee-cup"), reviewCategory: "Drip")
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
        brewCollectionView.allowsMultipleSelection = false
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
   
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let lastItem = lastSelectedItem, let tappedIndexPath = brewCollectionView.indexPathsForSelectedItems?.first  else {
            
            let tappedBrew = collectionView.cellForItem(at: indexPath)
            tappedBrew?.backgroundColor = UIColor.clear
            self.lastSelectedItem = brewCollectionView.cellForItem(at: indexPath)
            return
        }
        let lastTapped = brewCollectionView.indexPath(for: lastItem)
        self.brewCollectionView.deselectItem(at: lastTapped!, animated: true)
        lastItem.backgroundColor = UIColor.clear
        self.lastSelectedItem = brewCollectionView.cellForItem(at: tappedIndexPath)
        
        let tappedBrew = collectionView.cellForItem(at: indexPath)
        tappedBrew?.backgroundColor = UIColor.brown
    }
    
    
}
