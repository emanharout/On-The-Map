//
//  ListViewController.swift
//  On the Map
//
//  Created by Emmanuoel Eldridge on 6/15/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    //var studentLocationArray = [String]()
    
    var sessionID: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParseClient.sharedInstance.getStudentLocations(100, skip: 0, order: "-updatedAt") { (result, error) in
            
            if let error = error {
                print("\(error.localizedDescription)")
            } else if let result = result {
                //print(result)
                self.tableView.reloadData()
            }
        }
    }
}



extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
