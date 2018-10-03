//
//  SecondViewController.swift
//  MoJoe
//
//  Created by Denise Grant on 8/21/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UISearchBarDelegate {

  
    @IBOutlet weak var searchForShops: UISearchBar!

    
    @IBAction func tapHideKeyboard(_ sender: Any) {
        self.searchForShops.resignFirstResponder()
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       // self.searchForShops.delegate = self.. this goes with searchbarSearchButtonCLicked
    }

    
    
    private func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        
        self.searchForShops.endEditing(true)
    }
    
    

    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

