//
//  MapViewController.swift
//  On the Map
//
//  Created by Emmanuoel Eldridge on 6/15/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var sessionID: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        sessionID = UdacityClient.sharedInstance.sessionID
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
