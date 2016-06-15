//
//  LoginViewController.swift
//  On the Map
//
//  Created by Emmanuoel Eldridge on 6/11/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var debugLabel: UILabel!

    
    @IBAction func loginButton(sender: UIButton) {
        OTMClient.sharedInstance().authorizeUser(userNameTextField.text!, password: passwordTextField.text!) { 
            
            print("HURRAY")
            
        }
        
        // Login
        // Update Label if buggy
    }
    
    func loginWithCredentials(userName: String, password: String) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
