//
//  ViewController.swift
//  VirtualTourist
//
//  Created by sophia liu on 8/2/21.
//

import UIKit
import MapKit

// TODO: Add anotation view
// add long press to drop pin
// link the location to the next view


class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var coordinate2D = CLLocationCoordinate2DMake(40.8367321, 14.2468856)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        navigationItem.backButtonTitle = "OK"
        setupMapRegion()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    private func setupMapRegion() {
        
        // Define the region
        let region = MKCoordinateRegion(center: coordinate2D, latitudinalMeters: 100, longitudinalMeters: 100)
        
        mapView.region = region
        
        addPin()
    }
    
    private func addPin() {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate2D
        pin.title = "new pin"
        pin.subtitle = "new pin for testing"
        mapView.addAnnotation(pin)
    }
    
}


extension MapViewController: MKMapViewDelegate {
    
    // TODO: Add anotation view
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        return true
//    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let vc = storyboard?.instantiateViewController(identifier: "photoCollectionViewController") as! PhotoCollectionViewController
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

