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
            (result, error) in
            
            self.performUpdateOnMainThread() {
                
                let destinationVC = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as? UITabBarController
                self.presentViewController(destinationVC!, animated: true, completion: nil)
            }
            
        }
        
        // Login
        // Update Label if buggy
    }
    
    // TODO: Add AlertController for login failure
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // TODO: Move to GDC Blackbox
    func performUpdateOnMainThread(completionHandler: ()->Void) {
        let mainQueue = dispatch_get_main_queue()
        dispatch_async(mainQueue) {
            completionHandler()
        }
    }
    

}
