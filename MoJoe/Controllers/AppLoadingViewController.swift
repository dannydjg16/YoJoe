//
//  AppLoadingViewController.swift
//  MoJoe
//
//  Created by Daniel Grant on 10/24/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import UIKit
import Firebase

class AppLoadingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Check log in status
        Auth.auth().addStateDidChangeListener{ auth, user in
            
            if user != nil {
                
                let mainTabController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
                
                mainTabController.selectedViewController = mainTabController.viewControllers?[1]
                
                
                self.present(mainTabController, animated: true, completion: nil)
            }
            
            if user == nil {
                
                self.performSegue(withIdentifier: "firstSegue", sender: self)
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}






