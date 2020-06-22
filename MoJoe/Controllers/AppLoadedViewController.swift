//
//  AppLoadedViewController.swift
//  MoJoe
//
//  Created by Daniel Grant on 6/22/20.
//  Copyright © 2020 Daniel Grant. All rights reserved.
//

import UIKit
import Firebase

class AppLoadedViewController: UIViewController {

    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let user = user else {
            
            self.performSegue(withIdentifier: "firstSegue", sender: self)
            return
        }
        
        let mainTabController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
        
        mainTabController.selectedViewController = mainTabController.viewControllers?[0]
        
        
        self.present(mainTabController, animated: true, completion: nil)

    }
    


}
