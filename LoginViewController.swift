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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    
    @IBAction func loginButton(sender: UIButton) {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        UdacityClient.sharedInstance.authorizeUser(userNameTextField.text!, password: passwordTextField.text!) {
            (success, error) in
            
            self.performUpdateOnMainQueue{
                if success {
                    self.stopActivityIndicator(self.activityIndicator)
                    self.logIntoApp()
                } else if let error = error {
                    self.stopActivityIndicator(self.activityIndicator)
                    self.displayErrorAlert(error)
                }
            }
        }
    }
    
    
    // TODO: Add Sign Up for Udacity Account link in label
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidden = true
    }
    
    func logIntoApp() {
        let destinationVC = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as? UITabBarController
        presentViewController(destinationVC!, animated: true, completion: nil)
    }
}


extension UIViewController {
    func displayErrorAlert(error: NSError) {
        print("Error Code: \(error.code) - Localized Desc: \(error.localizedDescription)")
        
        let errorString: String
        
        switch error.code {
        case -1001:
            errorString = "Error due to poor internet connection."
        case 1:
            errorString = "Could not login due to incorrect username or password"
        case 8:
            errorString = "Could not locate address on map"
        case 10...20:
            errorString = "Could not download student data"
        default:
            errorString = "Networking error. Please try again later."
        }
        
        let alertController = UIAlertController(title: "Login Error", message: errorString, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(action)
        
        presentViewController(alertController, animated: true, completion: nil)
    }

    func performUpdateOnMainQueue(completionHandler: ()->Void) {
        let mainQueue = dispatch_get_main_queue()
        dispatch_async(mainQueue) {
            completionHandler()
        }
    }

    func stopActivityIndicator(indicator: UIActivityIndicatorView) {
        indicator.stopAnimating()
        indicator.hidden = true
    }
    
}
