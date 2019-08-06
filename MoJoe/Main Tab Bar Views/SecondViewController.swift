//
//  SecondViewController.swift
//  MoJoe
//
//  Created by Denise Grant on 8/21/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate {

  
    @IBOutlet weak var searchForShops: UISearchBar!
    @IBOutlet weak var searchTField: UITextField!
    
  
    @IBAction func printDate(_ sender: Any) {
        let date = Date()
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions.insert(.withFractionalSeconds)
        
        print("\(dateFormatter.string(from: date)) FUCKKKKKKKK")
    }
    
    
    
    
    @IBAction func tapHideKeyboard(_ sender: Any) {
        self.searchForShops.resignFirstResponder()
        self.searchTField.resignFirstResponder()
     
    }
    

    private func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        
        self.searchForShops.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        return true
    }
    //2) this function runs when the text field returns true after it is no longer the first responder
    func textFieldDidEndEditing(_ textField: UITextField)  {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // self.searchForShops.delegate = self.. this goes with searchbarSearchButtonCLicked
        
    }


}

