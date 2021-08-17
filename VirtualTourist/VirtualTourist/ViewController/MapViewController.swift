//
//  ViewController.swift
//  VirtualTourist
//
//  Created by sophia liu on 8/2/21.
//

import UIKit
import MapKit
import CoreData

// TODO: Add anotation view
// add long press to drop pin
// link the location to the next view


class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
        
    // TODO: Figure out the
//    var pins: [Pin] = []
    var dataController: DataController!
    var testing: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        navigationItem.backButtonTitle = "OK"
        loadSavedMapRegion()
        loadGestureRecognizer()
        print(testing)
        
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        
        do {
            let pins = try dataController.viewContext.fetch(fetchRequest)
            for pin in pins {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
                annotation.title = pin.title
                self.mapView.addAnnotation(annotation)
            }
        
        } catch {
            print("Error fetching Pins: \(error)")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    private func loadSavedMapRegion() {
        if  let mapRegion = UserDefaults.standard.dictionary(forKey: "mapRegion") {
            let center = CLLocationCoordinate2D(latitude: mapRegion["latitude"]! as! CLLocationDegrees, longitude: mapRegion["longitude"]! as! CLLocationDegrees)
            let span = MKCoordinateSpan(latitudeDelta: mapRegion["latitudeDelta"]! as! CLLocationDegrees, longitudeDelta: mapRegion["longitudeDelta"]! as! CLLocationDegrees)
            
            mapView.region = MKCoordinateRegion(center: center, span: span)
        }
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
        placeMark(coordinate: selectedCoordinate) { placemark in
            var locationStr = ""
            if let placemark = placemark {
               
                if let city = placemark.locality {
                    locationStr += (city + ", ")
                }
                if let state = placemark.administrativeArea {
                    locationStr += (state + ", ")
                }
                if let country = placemark.country {
                    locationStr += country
                }
            } else {
                print("Not found")
            }
            pin.title = locationStr
        }
        mapView.addAnnotation(pin)
        savePin(pin)
    }
    
    func savePin(_ pin: MKPointAnnotation) {
        let location = Pin(context: dataController.viewContext)
        location.latitude = pin.coordinate.latitude
        location.longitude = pin.coordinate.longitude
        location.title = pin.title
        try? dataController.viewContext.save()
    }
    
    func placeMark(coordinate: CLLocationCoordinate2D, completionHandler: @escaping(CLPlacemark?) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemarks = placemarks {
                completionHandler(placemarks.first)
            } else {
                completionHandler(nil)
            }
        }
    }
}


extension MapViewController: MKMapViewDelegate {
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        let mapRegion: [String: CLLocationDegrees] = [
            "latitude": mapView.region.center.latitude,
            "longitude": mapView.region.center.longitude,
            "latitudeDelta": mapView.region.span.latitudeDelta,
            "longitudeDelta": mapView.region.span.longitudeDelta
        ]
        
        UserDefaults.standard.setValue(mapRegion, forKey: "mapRegion")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoLight)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let vc = storyboard?.instantiateViewController(identifier: "photoCollectionViewController") as! PhotoCollectionViewController
        
        if let annocation = view.annotation {
            vc.latitude = annocation.coordinate.latitude
            vc.longitude = annocation.coordinate.longitude
            if let title  = annocation.title {
                vc.headerTitle = title ?? ""
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

