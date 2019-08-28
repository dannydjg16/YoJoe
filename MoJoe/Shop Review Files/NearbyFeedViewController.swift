//
//  NearbyFeedViewController.swift
//  MoJoe
//
//  Created by Daniel Grant on 11/11/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation


class NearbyFeedViewController: UIViewController, CLLocationManagerDelegate{
    
    var shops: [String] = ["no shops"]
    var theUser = Auth.auth().currentUser
    var currentLocation: CLLocation!
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var shopSearchBar: UISearchBar!
    @IBOutlet weak var shopSearchTextField: UITextField!
    @IBOutlet weak var shopTableView: UITableView!
    
  
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//    }
    
    
    
    
    @IBAction func shopSearchButton(_ sender: Any) {
        
        guard let searchText = shopSearchTextField.text else {
            
            return
        }
        if CLLocationManager.locationServicesEnabled() {
       
            currentLocation = locationManager.location
            let latitude = currentLocation.coordinate.latitude
            let longitude = currentLocation.coordinate.longitude
            let theEndPoint = "term=\(searchText)&latitude=\(Double(latitude))&longitude=\(Double(longitude))"
        
        APIClient.shared.GET(endpoint: theEndPoint){ result in
            switch result {
            case .success(let json):
                DispatchQueue.main.async {
                    self.data = json
                    print(json)
                    
                
                }
            case .failure:
                break
            }
            
        }
    }
    }
        
        
        
        
//        if shops.count == 0 {
//            return
//        } else {
//            func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//                guard let theCurrentLocation: CLLocationCoordinate2D = manager.location?.coordinate, let mostCurrentLocation = locations.last else {
//                    return
//                }
//                 let theEndPoint = "term=\(shopSearchTextField.text)&latitude=\(theCurrentLocation.latitude)&longitude=\(theCurrentLocation.longitude)"
//
//                APIClient.shared.GET(endpoint: theEndPoint){ result in
//                    switch result {
//                    case .success(let json):
//                        DispatchQueue.main.async {
//                            self.data = json
//                            print(json)
//
//
//                        }
//                    case .failure:
//                        break
//                    }
//
//                }
//        }
//
//
//
//    }
    
    var data: Any = ""
    
    
 

    
    //MARK: tap gesture recognizer
    @IBAction func tapHideKeyboard(_ sender: Any) {
       
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shopSearchTextField.placeholder = "Search for Coffee"
        shopSearchTextField.delegate = self
        
//        APIClient.shared.GET(endpoint:"")  { result in
//        switch result {
//        case .success(let json):
//            DispatchQueue.main.async {
//                self.data = json
//                print(json)
//                let cat = "cat"
//                print("cat")
//                
//            }
//        case .failure:
//            break
//        }
//        
//    }

   
    }
}
















extension NearbyFeedViewController: UITableViewDelegate, UITableViewDataSource {
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return shops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = shopTableView.dequeueReusableCell(withIdentifier: "ShopsFromAPITestCell", for: indexPath) as! ShopsFromAPITestCell
        let shop = shops[indexPath.row]
        
        cell.shopLabel.text = shop
        
        return cell
    }
}



extension NearbyFeedViewController: UITextFieldDelegate {
    //UITextFieldDelegate(2) 1)- this is the function called when you hit the enter/retur/done button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        
        shopSearchTextField.resignFirstResponder()
        return true
    }
    //2) this function runs when the text field returns true after it is no longer the first responder
    func textFieldDidEndEditing(_ textField: UITextField)  {
        
        
    }
    
    
}
