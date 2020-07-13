//
//  CMRoastCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 3/24/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class CMRoastCell: UITableViewCell {
    
    private var roastTypes: [ReviewHelper] = []
    var lastSelectedItem: UICollectionViewCell?
    
    @IBOutlet private weak var roastCollectionView: UICollectionView!
    
    
    private func makeRoasts() -> [ReviewHelper] {
        
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
        
        self.roastCollectionView.delegate = self
        self.roastCollectionView.dataSource = self
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
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = roastCollectionView.cellForItem(at: indexPath) else {
            return
            
        }
        cell.backgroundColor = #colorLiteral(red: 0.812450707, green: 0.7277771831, blue: 0.3973348141, alpha: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let theLastSelectedItem = roastCollectionView.cellForItem(at: indexPath) else {
            return
            
        }
        
        lastSelectedItem = theLastSelectedItem
        
        guard
            let tappedRoast = collectionView.cellForItem(at: indexPath),
            let tappedRoastIndexPath = collectionView.indexPath(for: tappedRoast) else {
                return
        }
        
        switch tappedRoastIndexPath.row {
        case 0:
            tappedRoast.backgroundColor = #colorLiteral(red: 1, green: 0.8864783049, blue: 0.6726394296, alpha: 1)
        case 1:
            tappedRoast.backgroundColor = #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1)
        case 2:
            tappedRoast.backgroundColor = #colorLiteral(red: 0.3104858994, green: 0.2067391574, blue: 0.1192429289, alpha: 1)
        default:
            tappedRoast.backgroundColor = UIColor.brown
        }
        
    }
}
