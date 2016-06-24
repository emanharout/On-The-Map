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
        UdacityClient.sharedInstance.authorizeUser(userNameTextField.text!, password: passwordTextField.text!) {
            (success, error) in
            
            if success {
                self.performUpdateOnMainThread() {
                    self.logIntoApp()
                }
                
            } else if let error = error {
                self.performUpdateOnMainThread() {
                    print("\(error)")
                    self.displayErrorAlert(error)
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

    func displayErrorAlert(error: NSError) {
        print("Error Code: \(error.code) and Desc: \(error.localizedDescription)")
        
        let errorString: String
        
        switch error.code {
        case -1001:
            errorString = "Could not login due to poor internet connection."
        case 1:
            errorString = "Could not login due to incorrect username or password"
        default:
            errorString = "There was an error when attempting to log in, please try again later."
        }
        
        let alertController = UIAlertController(title: "Login Error", message: errorString, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(action)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}
