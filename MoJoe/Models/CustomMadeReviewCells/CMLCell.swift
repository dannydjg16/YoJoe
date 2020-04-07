//
//  CMLCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 3/24/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit
import CoreLocation
class CMLCell: UITableViewCell, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!
    @IBOutlet weak var locationField: UITextField!
   
    
    @IBAction func locationButton(_ sender: Any) {
       locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
    }
    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       self.locationField.delegate = self
        
       
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}

extension CMLCell: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}


