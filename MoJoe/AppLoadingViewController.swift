//
//  AppLoadingViewController.swift
//  MoJoe
//
//  Created by Daniel Grant on 10/24/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import UIKit

class AppLoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        

        
        let isLoggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
      
        //if the user is not logged in, i want them to go to the loginVC through the firstSegue
        if isLoggedIn == false {
      
            self.performSegue(withIdentifier: "firstSegue", sender: self)
        }
       
        
        
        let mainTabController = storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
        
        mainTabController.selectedViewController = mainTabController.viewControllers?[2]
        
        present(mainTabController, animated: true, completion: nil)
        
    }
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
     
     
     
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 

}

