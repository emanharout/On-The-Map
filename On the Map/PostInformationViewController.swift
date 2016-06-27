//
//  PostInformationViewController.swift
//  On the Map
//
//  Created by Emmanuoel Eldridge on 6/26/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit
import MapKit

class PostInformationViewController: UIViewController, UIToolbarDelegate {
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchMapStackView: UIStackView!
    
    
    
    @IBOutlet weak var shareStackView: UIStackView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    var annotationsArray = [MKPointAnnotation]()
    
    
    @IBAction func searchMap() {
        activityIndicatorView.hidden = false
        activityIndicatorView.startAnimating()
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(textField.text!) { (placemarks, error) in
            
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.hidden = true
            
            if let error = error {
                print("Error Code Is: \(error.code)")
                self.displayErrorAlert(error)
            } else if let placemarks = placemarks {
                self.mapView.removeAnnotations(self.annotationsArray)
                let annotation = MKPointAnnotation()
                annotation.coordinate = (placemarks[0].location?.coordinate)!
                self.annotationsArray.append(annotation)
                self.mapView.addAnnotation(annotation)
                self.zoomToAnnotation(annotation)
                
                self.searchMapStackView.hidden = true
                self.shareStackView.hidden = false
            }
        }
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
