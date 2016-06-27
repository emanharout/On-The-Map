//
//  ListViewController.swift
//  On the Map
//
//  Created by Emmanuoel Eldridge on 6/15/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit
import SafariServices

class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    //var studentLocationArray = [String]()
    
    var sessionID: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParseClient.sharedInstance.getStudentLocations(100, skip: 0, order: "-updatedAt") { (result, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                self.displayErrorAlert(error)
            } else if result != nil {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addStudentInformation() {
        
    }
    
}


extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = StudentInformation.studentArray[indexPath.row]
        let mediaURL = student.mediaURL
        guard let url = NSURL(string: mediaURL) else {
            return
        }

        if url.scheme != "" {
            let safariViewController = SFSafariViewController(URL: url)
            safariViewController.delegate = self
            presentViewController(safariViewController, animated: true, completion: nil)
        } else {
            UIApplication.sharedApplication().openURL(url)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell", forIndexPath: indexPath) as! StudentCell
        let student = StudentInformation.studentArray[indexPath.row]
        cell.studentName.text = "\(student.firstName) \(student.lastName)"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformation.studentArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
}

extension ListViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}