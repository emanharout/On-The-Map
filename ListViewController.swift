
import UIKit
import SafariServices

class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParseClient.sharedInstance.getStudentLocations(100, skip: 0, order: "-updatedAt") { (result, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                self.performUpdateOnMainQueue(){
                    self.displayErrorAlert(error)
                }
            } else {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func reloadData() {
        ParseClient.sharedInstance.getStudentLocations(100, skip: 0, order: "-updatedAt") { (result, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                self.performUpdateOnMainQueue(){
                    self.displayErrorAlert(error)
                }
            } else {
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func logoutPressed(sender: AnyObject) {
        UdacityClient.sharedInstance.taskForDELETEMethod(UdacityClient.Methods.UdacitySession, parameters: [String:AnyObject]()) { (result, error) in

            if let error = error {
                print(error.localizedDescription)
            } else {
                self.performUpdateOnMainQueue(){
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
}


extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = StudentManager.sharedInstance.studentArray[indexPath.row]
        let mediaURL = student.mediaURL
        guard let url = NSURL(string: mediaURL) else {
            return
        }

        if url.scheme != "" {
            let safariViewController = SFSafariViewController(URL: url)
            safariViewController.delegate = self
            presentViewController(safariViewController, animated: true, completion: nil)
        } else {
            let error = NSError(domain: "tableView didSelectRowAtIndexPath", code: 881, userInfo: nil)
            displayErrorAlert(error)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell", forIndexPath: indexPath) as! StudentCell
        let student = StudentManager.sharedInstance.studentArray[indexPath.row]
        cell.studentName.text = "\(student.firstName) \(student.lastName)"
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentManager.sharedInstance.studentArray.count
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
