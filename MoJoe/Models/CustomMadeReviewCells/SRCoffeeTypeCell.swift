//
//  SRCoffeeTypeCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 4/29/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class SRCoffeeTypeCell: UITableViewCell {

    @IBOutlet weak var coffeeTypeCV: UICollectionView!
   
    var lastSelectedItem: UICollectionViewCell?
    
    var coffeeTypes: [String] = ["Cappucino", "Americano", "Latte", "Hot Coffee"]
    

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension SRCoffeeTypeCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = coffeeTypes[indexPath.row]
        
        
        
        
        let coffeeTypeCell = coffeeTypeCV.dequeueReusableCell(withReuseIdentifier: "SingleLabelCollectionViewCell", for: indexPath) as! SingleLabelCollectionViewCell
        
        
        
       // coffeeTypeCell.setLabel(label: type)
        
        coffeeTypeCell.coffeeTypeLabel.text = type
        
        coffeeTypeCell.layer.borderColor = UIColor.black.cgColor
        coffeeTypeCell.layer.borderWidth = 1
        
        return coffeeTypeCell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let lastItem = lastSelectedItem,
//              let tappedIndexPath = coffeeTypeCV.indexPathsForSelectedItems?.first  else {
//
//            let tappedType = collectionView.cellForItem(at: indexPath)
//            tappedType?.backgroundColor = UIColor.brown
//            self.lastSelectedItem = coffeeTypeCV.cellForItem(at: indexPath)
//            return
//        }
//        let lastTapped = coffeeTypeCV.indexPath(for: lastItem)
//        self.coffeeTypeCV.deselectItem(at: lastTapped!, animated: true)
//        lastItem.backgroundColor = UIColor(red: 0.8, green: 0.7333, blue: 0.4392, alpha: 1)
//        self.lastSelectedItem = coffeeTypeCV.cellForItem(at: tappedIndexPath)
//
//        guard let tappedType = collectionView.cellForItem(at: indexPath) else {return}
//
//            tappedType.backgroundColor = UIColor.brown
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = coffeeTypeCV.cellForItem(at: indexPath) else { return }
        cell.backgroundColor = #colorLiteral(red: 0.812450707, green: 0.7277771831, blue: 0.3973348141, alpha: 1)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let theLastSelectedItem = coffeeTypeCV.cellForItem(at: indexPath) else { return }
        theLastSelectedItem.backgroundColor = UIColor.brown
        lastSelectedItem = theLastSelectedItem
    }
    
}
