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
        
        let darkRoast = ReviewHelper(reviewImage: #imageLiteral(resourceName: "shop"), reviewCategory: "Dark Roast")
        let mediumRoast = ReviewHelper(reviewImage: #imageLiteral(resourceName: "menu"), reviewCategory: "Medium Roast")
        let lightRoast = ReviewHelper(reviewImage: #imageLiteral(resourceName: "kettle"), reviewCategory: "Light Roast")
        
        tempRoasts.append(darkRoast)
        tempRoasts.append(mediumRoast)
        tempRoasts.append(lightRoast)
        
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
        
        let tappedBrew = collectionView.cellForItem(at: indexPath)
        tappedBrew?.backgroundColor = UIColor.brown
    }
}
