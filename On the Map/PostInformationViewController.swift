
import UIKit
import MapKit

class PostInformationViewController: UIViewController, UIToolbarDelegate {

    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var mapStringTextField: UITextField!
    @IBOutlet weak var searchMapStackView: UIStackView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var shareStackView: UIStackView!
    var annotationsArray = [MKPointAnnotation]()

    var mapString: String?
    var mediaURL: String?
    var latitude: Float?
    var longitude: Float?

    @IBAction func searchMap() {
        activityIndicatorView.hidden = false
        activityIndicatorView.startAnimating()

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(mapStringTextField.text!) { (placemarks, error) in

            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.hidden = true

            if let error = error {
                self.displayErrorAlert(error)
                print(error.code)
            } else if let placemarks = placemarks {
                self.mapView.removeAnnotations(self.annotationsArray)
                let annotation = MKPointAnnotation()
                annotation.coordinate = (placemarks[0].location?.coordinate)!

                self.mapString = self.mapStringTextField.text
                self.latitude = Float(annotation.coordinate.latitude)
                self.longitude = Float(annotation.coordinate.longitude)

                self.annotationsArray.append(annotation)
                self.mapView.addAnnotation(annotation)
                self.zoomToAnnotation(annotation)

                self.searchMapStackView.hidden = true
                self.shareStackView.hidden = false
            }
        }
    }

    @IBAction func submitStudentInfo(sender: AnyObject) {

        guard let urlText = urlTextField.text where !urlText.isEmpty else {
            self.displayAlert()
            return
        }

        mediaURL = urlText

        UdacityClient.sharedInstance.getUserInfo() { (success, error) in
            if let error = error {
                self.performUpdateOnMainQueue{
                    self.displayErrorAlert(error)
                }
            } else {
                if let uniqueKey = UdacityClient.sharedInstance.accountKey, firstName = UdacityClient.sharedInstance.userFirstName, lastName = UdacityClient.sharedInstance.userLastName, mapString = self.mapString, mediaURL = self.mediaURL, latitude = self.latitude, longitude = self.longitude {

                    let studentInfo = StudentInformation(objectId: nil, uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)

                    ParseClient.sharedInstance.taskForPOSTMethod(ParseClient.Constants.Scheme, host: ParseClient.Constants.Host, path: ParseClient.Methods.StudentLocation, parameters: [String: AnyObject](), student: studentInfo) { (result, error) in

                        if let error = error {
                            self.performUpdateOnMainQueue{
                                print(error.localizedDescription)
                                self.displayErrorAlert(error)
                                print("Error code for Submission: \(error.code)")
                            }

                        } else if result != nil {
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    }
                }
            }
        }
    }

    func displayAlert() {
        let alertController = UIAlertController(title: "Text Field is Empty", message: "Please enter a url", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(action)

        presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func cancelPostInformation() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        shareStackView.hidden = true
        activityIndicatorView.hidden = true
        topToolbar.delegate = self
        positionForBar(topToolbar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func zoomToAnnotation(annotation: MKPointAnnotation) {
        let latDelta: CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }

    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}
