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
            (success, error) in
            
            if success {
                self.performUpdateOnMainThread() {
                    
                    self.logIntoApp()
                }
            } else if let error = error {
                self.performUpdateOnMainThread() {
                    self.debugLabel.text = "\(error)"
                }
            }
        }
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
    
    func logIntoApp() {
        let destinationVC = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as? UITabBarController
        presentViewController(destinationVC!, animated: true, completion: nil)
    }

}
