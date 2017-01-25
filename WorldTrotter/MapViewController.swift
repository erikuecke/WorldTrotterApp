//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Erik Uecke on 1/23/17.
//  Copyright © 2017 Erik Uecke. All rights reserved.
//

//import Foundation

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    override func loadView() {
        // Create a map view
        mapView = MKMapView()
        
        // Set it as *the view of this view controller
        view = mapView
        
        // Creating the map options bars for different views.
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        // Adding a target-action pair to the segmentd control associate it with the .valueChanged event
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        
        
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        // let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.topAnchor)
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        
        // let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        // let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        // User location update using MKMapViewDelegate, CLLocationManagerDelegate
        mapView.delegate = self
        locationManager = CLLocationManager()
        
        
        initLocalizationButton(segmentedControl)
        
    }
    
    override func viewDidLoad() {
        print("MapViewController loaded its view")
    }
    
    func mapTypeChanged(_ segControl: UISegmentedControl) {
        
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    func initLocalizationButton(_ anyView: UIView!) {
        let localizationButtion = UIButton.init(type: .system)
        localizationButtion.setTitle("Localization", for: .normal)
        localizationButtion.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(localizationButtion)
        
        // Constraints
        let topButtonConstraint = localizationButtion.topAnchor.constraint(equalTo: anyView.topAnchor, constant: 32)
        let leadingButtonConstraint = localizationButtion.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        let trailingButtonConstraint = localizationButtion.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        
        // Activating constraints
        topButtonConstraint.isActive = true
        leadingButtonConstraint.isActive = true
        trailingButtonConstraint.isActive = true
        
        localizationButtion.addTarget(self, action: #selector(MapViewController.showLocalization(sender:)), for: .touchUpInside)
    }
    
    func showLocalization(sender: UIButton!) {
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        // This is a method from MKMapViewDelegate, fires up when the user's location changes
        let zoomedInCurrentLocation = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)
        mapView.setRegion(zoomedInCurrentLocation, animated: true)
    }
}
