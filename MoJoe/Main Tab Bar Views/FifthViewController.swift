//
//  FifthViewController.swift
//  MoJoe
//
//  Created by Denise Grant on 8/21/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class FifthViewController: UIViewController {
   
    @IBOutlet weak var yourName: UILabel!
        private lazy var debutYourBrew: DebutYourBrew = {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "DebutYourBrew") as! DebutYourBrew
    
           self.add(asChildViewController: viewController)
    
            return viewController
        }()
    
    @IBAction func presentVC(_ sender: Any) {
        addChild(debutYourBrew)
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    @IBAction func tapKeyboardHide(_ sender: Any) {
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("profile view will appear")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("profile view will dissapear")
    }
    

    
 
    
    
    
    //logout----> this is 100% copied so i will probably have to chane it IDK though. Like literally 100%. I actually copy and pasted and the website i used popped up.
    @IBAction func logout(_ sender: Any) {
        
        
      
        let user = Auth.auth().currentUser!
        let onlineRef = Database.database().reference(withPath: "online/\(user.uid)")
        
     
        onlineRef.removeValue { (error, _) in
            
           
            if let error = error {
                print("Removing online failed: \(error)")
                return
            }
            
          
            do {
                try Auth.auth().signOut()
                self.dismiss(animated: true, completion: nil)
            } catch (let error) {
                print("Auth sign out failed: \(error)")
            }
        }

        
        
      
        
        
        
        
        
          dismiss(animated: true, completion: nil)
     
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        yourName.text = Auth.auth().currentUser?.displayName
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}



extension FifthViewController: UITextFieldDelegate {
    //UITextFieldDelegate(2) 1)- this is the function called when you hit the enter/retur/done button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        return true
    }
    //2) this function runs when the text field returns true after it is no longer the first responder
    func textFieldDidEndEditing(_ textField: UITextField)  {
        
    }
}
