//
//  ThirdViewController.swift
//  MoJoe
//
//  Created by Denise Grant on 8/21/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class ThirdViewController: UIViewController, UITextFieldDelegate {
    
  
    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D!
    @IBOutlet weak var nearMeMap: MKMapView!
    let mapPin = MKPointAnnotation()
    var mapSearchController: UISearchController? = nil
    
    
    
    
    @IBAction func tapHideKeyboard(_ sender: Any) {
        
    }
 
   
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        return true
    }
    //2) this function runs when the text field returns true after it is no longer the first responder
    func textFieldDidEndEditing(_ textField: UITextField)  {
        
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        }
        //MARK: Setting up the search controller
        let mapSearchTable = storyboard!.instantiateViewController(withIdentifier: "MapSearchTable") as! MapSearchTable
        mapSearchController = UISearchController(searchResultsController: mapSearchTable)
        mapSearchController?.searchResultsUpdater = mapSearchTable
        
        //MARK: Setting up the search bar
        let mapSearchBar = mapSearchController!.searchBar
        mapSearchBar.sizeToFit()
        mapSearchBar.placeholder = "Find a Great Coffee"
        navigationItem.titleView = mapSearchController?.searchBar

        mapSearchController?.hidesNavigationBarDuringPresentation = false
        mapSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    
        mapSearchTable.nearMeMap = nearMeMap
    }
    
  
}


extension ThirdViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let theCurrentLocation: CLLocationCoordinate2D = manager.location?.coordinate, let mostCurrentLocation = locations.last else {
            return
        }
        currentLocation = theCurrentLocation
        
        let mapCenter = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        let mapCircle = MKCoordinateRegion(center: mapCenter, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        self.nearMeMap.setRegion(mapCircle, animated: true)
        mapPin.coordinate = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        //nearMeMap.addAnnotation(mapPin)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let danny = 1
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager.requestLocation()
        }
    }




}
