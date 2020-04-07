//
//  SRLocationCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 4/28/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class SRLocationCell: UITableViewCell {

    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    
    //@IBOutlet weak var locationSearchBar: UISearchBar!
    
   // var locationSearchController: UISearchController? = nil
    //let locationTableView = 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        locationTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        //self.locationSearchBar.delegate = self
        
//
//        locationSearchBar.sizeToFit()
//        locationSearchBar.placeholder = "Coffee Shop"
//
//
//        locationSearchController?.hidesNavigationBarDuringPresentation = true
//        locationSearchController?.dimsBackgroundDuringPresentation = true
//
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

}


extension SRLocationCell: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var ShopLocationSearchTable = storyboard.instantiateViewController(withIdentifier: "ShopLocationSearchTable") as! ShopLocationSearchTable
//        locationSearchController = UISearchController(searchResultsController: ShopLocationSearchTable)
//        locationSearchController?.searchResultsUpdater = ShopLocationSearchTable
//        print("hello")
        return true
    }
}


extension SRLocationCell: UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}


