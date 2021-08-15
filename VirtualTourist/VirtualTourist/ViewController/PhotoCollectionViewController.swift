//
//  PhotoCollectionViewController.swift
//  VirtualTourist
//
//  Created by Sophia Lu on 8/8/21.
//

import UIKit
import MapKit

class PhotoCollectionViewController: UIViewController {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var individualMapView: MKMapView!
    
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    
    var coordinate2D: CLLocationCoordinate2D!
    var photos: [PhotoInfo] = []
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        coordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        setupMapRegion()
       
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: view.frame.width/3 - 4, height: view.frame.width/3 - 4)
        photoCollectionView.collectionViewLayout = layout
        
        page = 0
        searchPhotos(pageCount: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        
    }
    
    private func setupMapRegion() {
        
        // Define the region
        let region = MKCoordinateRegion(center: coordinate2D, latitudinalMeters: 100, longitudinalMeters: 100)
        
        individualMapView.region = region
        
        addPin()
    }
    
    private func addPin() {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate2D
        individualMapView.addAnnotation(pin)
    }
    
    private func searchPhotos(pageCount: Int) {
        FlickerClient.getPhotoList(lat: String(latitude), lon: String(longitude), page: pageCount, completion: {data,error in
            self.photos = data
            
            DispatchQueue.main.async {
                self.photoCollectionView.reloadData()
            }
        })
    }
        
    @IBAction func loadNewCollection(_ sender: Any) {
        page += 1
        searchPhotos(pageCount: page)
    }
}

extension PhotoCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell( withReuseIdentifier: "photoCollectionCell", for: indexPath) as! PhotoCollectionViewCell
        
        cell.cellImageView.image = UIImage(named: "ImagePlaceholder")
        
        FlickerClient.downloadImage(photo: photos[indexPath.row]) {data, error in
            guard let data = data else {
                return
            }
            let image = UIImage(data: data)
            cell.cellImageView.image = image
            cell.setNeedsLayout()
        }
        
        return cell
    }
}
