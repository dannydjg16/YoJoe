//
//  ShopLocationSearchTable.swift
//  MoJoe
//
//  Created by Daniel Grant on 7/7/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class ShopLocationSearchTable: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

   

        return cell
    }
    

}

extension ShopLocationSearchTable: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
     
        
        
    }
    
}
