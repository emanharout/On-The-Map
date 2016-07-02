
import UIKit
import SafariServices
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var annotationsArray = [MKPointAnnotation]()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        ParseClient.sharedInstance.getStudentLocations(100, skip: 0, order: "-updatedAt") { (result, error) in
            if let error = error {
                print(error)
                self.displayErrorAlert(error)
            } else if let result = result {
                self.addAnnotationsToMapView(result)
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        mapView.removeAnnotations(annotationsArray)
    }

    func addAnnotationsToMapView(studentLocations: [StudentInformation]) {
        for studentLocation in studentLocations {
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: Double(studentLocation.latitude), longitude: Double(studentLocation.longitude))

            annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
            annotation.subtitle = "\(studentLocation.mediaURL)"
            annotation.coordinate = coordinate
            self.annotationsArray.append(annotation)
            self.mapView.addAnnotation(annotation)
        }
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("pinView") as? MKPinAnnotationView

        if annotationView == nil {
            annotationView = MKPinAnnotationView()
            annotationView?.canShowCallout = true
            annotationView?.pinTintColor = UIColor.redColor()
            annotationView?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let urlString = view.annotation?.subtitle else {
            return
        }
        guard let url = NSURL(string: urlString!) else {
            return
        }
        
        if url.scheme != "" {
            let safariViewController = SFSafariViewController(URL: url)
            safariViewController.delegate = self
            presentViewController(safariViewController, animated: true, completion: nil)
        } else {
            let error = NSError(domain: "mapView annotationView calloutAccessoryControlTapped", code: 880, userInfo: nil)
            displayErrorAlert(error)
        }
    }

    @IBAction func logoutPressed (sender: AnyObject) {
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

extension MapViewController: SFSafariViewControllerDelegate {

    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
