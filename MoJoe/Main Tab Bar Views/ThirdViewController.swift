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

class ThirdViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var shopsTextField: UITextField!
    
    @IBOutlet weak var exampleButton: UILabel!
    
    @IBOutlet weak var nearMeMap: MKMapView!
    
    
    
    
    
    
    
    
    @IBAction func unwinded (segue: UIStoryboardSegue) {
        exampleButton.text = "unwinded"
    }
    
    @IBAction func tapHideKeyboard(_ sender: Any) {
        self.shopsTextField.resignFirstResponder()
    }
 
    var danny = FirstViewController.trueFalse.realTF
    
    
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
       
        var mapOrigin = CLLocationCoordinate2DMake(41.8077, 72.2540)
        
        var mapReach = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        var mapRegion = MKCoordinateRegion(center: mapOrigin, span: mapReach)
        
        self.nearMeMap.setRegion(mapRegion, animated: true)
    }
}
