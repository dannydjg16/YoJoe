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

class ThirdViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var shopsTextField: UITextField!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D!
    @IBOutlet weak var nearMeMap: MKMapView!
    let mapPin = MKPointAnnotation()
    
    
    
    
    @IBAction func tapHideKeyboard(_ sender: Any) {
        self.shopsTextField.resignFirstResponder()
    }
 
   
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        return true
    }
    //2) this function runs when the text field returns true after it is no longer the first responder
    func textFieldDidEndEditing(_ textField: UITextField)  {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let theCurrentLocation: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        currentLocation = theCurrentLocation
        
        guard let mostCurrentLocation = locations.last else {
            return
        }
        let mapCenter = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        let mapCircle = MKCoordinateRegion(center: mapCenter, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        self.nearMeMap.setRegion(mapCircle, animated: true)
        mapPin.coordinate = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        nearMeMap.addAnnotation(mapPin)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

    }
    
  
}
//these are gonna be the location manager functions

//extension ThirdViewController {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let theCurrentLocation: CLLocationCoordinate2D = manager.location?.coordinate else {
//            return
//        }
//        currentLocation = theCurrentLocation
//    }
//}
