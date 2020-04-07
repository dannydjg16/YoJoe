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

        // Do any additional setup after loading the view.
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
// This checks if the user is logged in and if so brings them to the main part of the app, if not, it continues the
        Auth.auth().addStateDidChangeListener{ auth, user in
            if user != nil {
                let mainTabController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
                
            mainTabController.selectedViewController = mainTabController.viewControllers?[0]
       
                
                self.present(mainTabController, animated: true, completion: nil)
            }
            if user == nil {
                self.performSegue(withIdentifier: "firstSegue", sender: self)
            }
            
        }
        
     
        
      
}
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
     
     
     
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 

}

