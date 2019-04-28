//
//  CMRoastCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 3/24/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class CMRoastCell: UITableViewCell {

    @IBOutlet weak var roastCollectionView: UICollectionView!
    var roastTypes: [ReviewHelper] = []
    var lastSelectedItem: UICollectionViewCell?
    
    
    func makeRoasts() -> [ReviewHelper] {
        var tempRoasts: [ReviewHelper] = []
        
        let darkRoast = ReviewHelper(reviewImage: #imageLiteral(resourceName: "coffee-beans"), reviewCategory: "Dark Roast")
        let mediumRoast = ReviewHelper(reviewImage: #imageLiteral(resourceName: "coffee-beans"), reviewCategory: "Medium Roast")
        let lightRoast = ReviewHelper(reviewImage: #imageLiteral(resourceName: "coffee-beans"), reviewCategory: "Light Roast")
        
        tempRoasts.append(lightRoast)
        tempRoasts.append(mediumRoast)
        tempRoasts.append(darkRoast)
       
        
        return tempRoasts
    }
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        roastTypes = makeRoasts()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}


extension CMRoastCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let roast = roastTypes[indexPath.row]
        
        let roastTypeCell = roastCollectionView.dequeueReusableCell(withReuseIdentifier: "RoastTypeCVCell", for: indexPath) as! RoastTypeCVCell
        
        
        roastTypeCell.setCell(roast: roast)
        
        roastTypeCell.layer.borderColor = UIColor.darkGray.cgColor
        roastTypeCell.layer.borderWidth = 2
        
        return roastTypeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let lastItem = lastSelectedItem, let tappedIndexPath = roastCollectionView.indexPathsForSelectedItems?.first  else {
            
            let tappedBrew = collectionView.cellForItem(at: indexPath)
            tappedBrew?.backgroundColor = UIColor.clear
            self.lastSelectedItem = roastCollectionView.cellForItem(at: indexPath)
            return
        }
        let lastTapped = roastCollectionView.indexPath(for: lastItem)
        self.roastCollectionView.deselectItem(at: lastTapped!, animated: true)
        lastItem.backgroundColor = UIColor.clear
        self.lastSelectedItem = roastCollectionView.cellForItem(at: tappedIndexPath)
        
        guard let tappedBrew = collectionView.cellForItem(at: indexPath), let tappedBrewIndexPath = collectionView.indexPath(for: tappedBrew) else {return}
        switch tappedBrewIndexPath.row {
        case 0:
            tappedBrew.backgroundColor = UIColor.init(red: 0.83, green: 0.58, blue: 0.33, alpha: 1.0)
        case 1:
            tappedBrew.backgroundColor = UIColor.init(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0)
        case 2:
            tappedBrew.backgroundColor = UIColor.init(red: 0.4, green: 0.27, blue: 0.14, alpha: 1.0)
        default:
            tappedBrew.backgroundColor = UIColor.brown
        }
        
    }
}
