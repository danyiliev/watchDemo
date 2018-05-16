//
//  ViewController.swift
//  WeatherDemo
//
//  Created by Dany on 5/16/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Define DoubleTap gesture
        let lpgr = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(gestureReconizer:)))
        lpgr.numberOfTapsRequired = 2
        lpgr.delegate = self
        self.mapView.subviews[0].addGestureRecognizer(lpgr)
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: -

extension MapViewController: UIGestureRecognizerDelegate {
    
    // MARK: Gesture handler

    @objc func handleDoubleTap(gestureReconizer: UITapGestureRecognizer) {
        // get the tapped coordinate from the map
        let touchLocation = gestureReconizer.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation,toCoordinateFrom: mapView)
        
        // go to second weather page
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if  let vc = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController {
            vc.coordinateLoc = locationCoordinate
            self.show(vc, sender: self)
        }
    }
}

// MARK: -

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: Location Manager delegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        mapView.mapType = MKMapType.standard
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "I am here"
        annotation.subtitle = "current location"
        mapView.addAnnotation(annotation)
    }
}

