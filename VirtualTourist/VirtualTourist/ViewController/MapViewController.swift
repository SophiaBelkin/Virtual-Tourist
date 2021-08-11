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
        loadGestureRecognizer()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    private func setupMapRegion() {
        
        // Define the region
        let region = MKCoordinateRegion(center: coordinate2D, latitudinalMeters: 100, longitudinalMeters: 100)
        
        mapView.region = region
        
    }
    
    private func loadGestureRecognizer() {
        let longPressRecognizer =  UILongPressGestureRecognizer(target: self, action: #selector(recognizeLongPress))
    
        mapView.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func recognizeLongPress(_ sender: UILongPressGestureRecognizer)  {
        if sender.state != UIGestureRecognizer.State.began {
                  return
            }
        let location = sender.location(in: mapView)
        
        // Convert location to CLLocationCoordinate2D.
       let selectedCoordinate: CLLocationCoordinate2D = mapView.convert(location, toCoordinateFrom: mapView)
        
        // add pin
        let pin = MKPointAnnotation()
        pin.coordinate = selectedCoordinate
        pin.title = "new pin"
        pin.subtitle = "new pin for testing"
        mapView.addAnnotation(pin)
    }
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let vc = storyboard?.instantiateViewController(identifier: "photoCollectionViewController") as! PhotoCollectionViewController
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

