//
//  MapSearchTable.swift
//  MoJoe
//
//  Created by Daniel Grant on 4/16/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit
import MapKit



class MapSearchTable: UITableViewController {

    var tableItems: [MKMapItem] = []
    var nearMeMap: MKMapView? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let locationCell = tableView.dequeueReusableCell(withIdentifier: "LocationCell")!
        let locationItem = tableItems[indexPath.row].placemark
        locationCell.textLabel?.text = locationItem.name
        locationCell.detailTextLabel?.text = ""
        return locationCell
    }

}


extension MapSearchTable: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let nearMeMap = nearMeMap, let searchText = searchController.searchBar.text else { return }
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText
        searchRequest.region = nearMeMap.region
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: { response, _ in
            guard let response = response else { return }
            self.tableItems = response.mapItems
            self.tableView.reloadData()
        } )
        
        
    }
    
}

//{ response, _ in
//    guard let searchResponse = response else { return }
//    self.tableItems = response.mapItems
//    self.tableView.reloadData()
//}
