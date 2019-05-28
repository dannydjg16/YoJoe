//
//  SRShopTagsCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 4/28/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class SRShopTagsCell: UITableViewCell {

    var shopTags: [String] = ["Cozy", "Pleasant Atmosphere", "Great Service", "Poor Service", "Long Wait", "Short Wait", "Cheap", "Exepnsive"]
    
    var selectedTags: [String] = []
    
    @IBOutlet weak var shopTagsCollectionView: UICollectionView!
    
    var lastSelectedItem: UICollectionViewCell?
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
       
    }
    
    //func makeTagsString(selectedTags: [String]) -> String {
      //  
    //}
    
    override func awakeFromNib() {
   
        super.awakeFromNib()
        shopTagsCollectionView.allowsMultipleSelection = true
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }

}


extension SRShopTagsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let tag = shopTags[indexPath.row]
        
        let shopTagCell = shopTagsCollectionView.dequeueReusableCell(withReuseIdentifier: "OneLabelShopTagsCVC", for: indexPath) as! OneLabelShopTagsCVC
        
        shopTagCell.shopTagLabel.text = tag
        
        shopTagCell.layer.borderColor = UIColor.black.cgColor
        shopTagCell.layer.borderWidth = 1
        
        
        return shopTagCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = shopTagsCollectionView.cellForItem(at: indexPath) as? OneLabelShopTagsCVC else { return }
        cell.backgroundColor = #colorLiteral(red: 0.812450707, green: 0.7277771831, blue: 0.3973348141, alpha: 1)
        //selectedTags.remove(at: selectedTags.lastIndex(of: "\(cell.shopTagLabel.text)")!)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = shopTagsCollectionView.cellForItem(at: indexPath) as? OneLabelShopTagsCVC else { return }
        cell.backgroundColor = UIColor.brown
        lastSelectedItem = cell
        selectedTags.append(cell.shopTagLabel.text!)
        print("\(shopTagsCollectionView.indexPathsForSelectedItems)")
        
    }
    
   
   
    
}
