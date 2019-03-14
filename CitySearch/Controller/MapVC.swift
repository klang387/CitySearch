//
//  MapVC.swift
//  CitySearch
//
//  Created by Kevin Langelier on 3/13/19.
//  Copyright © 2019 Kevin Langelier. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var location: CLLocation!
    
    override func viewDidLoad() {
        centerMapOnLocation(location, radius: 5000000, animated: false)
        
    }
        
    override func viewDidAppear(_ animated: Bool) {
        centerMapOnLocation(location, radius: 20000, animated: true)
        
    }
    
    func centerMapOnLocation(_ location: CLLocation, radius: CLLocationDistance, animated: Bool) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.setRegion(coordinateRegion, animated: animated)
    }

}
