//
//  SRCoffeeTypeCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 4/29/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class SRCoffeeTypeCell: UITableViewCell {

    var lastSelectedItem: UICollectionViewCell?
    private var coffeeTypes: [String] = ["Cappucino", "Americano", "Latte", "Hot Coffee", "Cold Brew", "Iced Coffee", "Other"]
    
    @IBOutlet private weak var coffeeTypeCV: UICollectionView!
   

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    
}

extension SRCoffeeTypeCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = coffeeTypes[indexPath.row]
        
        let coffeeTypeCell = coffeeTypeCV.dequeueReusableCell(withReuseIdentifier: "SingleLabelCollectionViewCell", for: indexPath) as! SingleLabelCollectionViewCell
        
        coffeeTypeCell.coffeeTypeLabel.text = type
        
        coffeeTypeCell.layer.borderColor = UIColor.black.cgColor
        coffeeTypeCell.layer.borderWidth = 1
        
        return coffeeTypeCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = coffeeTypeCV.cellForItem(at: indexPath) else {
            return
        }
        cell.backgroundColor = #colorLiteral(red: 0.812450707, green: 0.7277771831, blue: 0.3973348141, alpha: 1)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let theLastSelectedItem = coffeeTypeCV.cellForItem(at: indexPath) else {
            return
        }
        
        theLastSelectedItem.backgroundColor = UIColor.brown
        lastSelectedItem = theLastSelectedItem
    }
    
    
}
