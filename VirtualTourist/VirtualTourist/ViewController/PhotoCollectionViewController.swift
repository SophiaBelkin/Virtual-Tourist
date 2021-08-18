//
//  PhotoCollectionViewController.swift
//  VirtualTourist
//
//  Created by Sophia Lu on 8/8/21.
//

import UIKit
import MapKit
import CoreData

class PhotoCollectionViewController: UIViewController {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var individualMapView: MKMapView!
    @IBOutlet weak var noImagesLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newCollectionBtn: UIButton!
    
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    var headerTitle: String = ""
    var coordinate2D: CLLocationCoordinate2D!
    var photos: [PhotoInfo] = []
    var page = 0
    var photosFromStorage: [Photo]!
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = headerTitle
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        coordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        // set map region based on user selection
        setupMapRegion()
        
        // Load photos from db
        loadPhotosFromStorage()
        
        if photosFromStorage.isEmpty {
            // Load photos from flicker api or core data
            fetchPhotos(pageCount: 0)
        }
        
        // show collection view flow layout
        showCollectionViewFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func prepareUI() {
        activityIndicator.isHidden = true
        if photos.count == 0 {
            photoCollectionView.isHidden = true
            noImagesLabel.isHidden = false
        } else {
            photoCollectionView.isHidden = false
            noImagesLabel.isHidden = true
        }
        showLoadingUI(isLoading: false)
    }
    
    
    private func showCollectionViewFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: view.frame.width/3 - 4, height: view.frame.width/3 - 4)
        photoCollectionView.collectionViewLayout = layout
    }
    
    private func setupMapRegion() {
        // Define the region
        let region = MKCoordinateRegion(center: coordinate2D, latitudinalMeters: 100, longitudinalMeters: 100)
        
        individualMapView.region = region
        
        addPin()
    }
    
    // Drop pin on the map view
    private func addPin() {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate2D
        individualMapView.addAnnotation(pin)
    }
    
    private func loadPhotosFromStorage() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pin == %@", pin)
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            photosFromStorage = result
        }
    }
    
    private func fetchPhotos(pageCount: Int) {
        FlickerClient.getPhotoList(lat: String(latitude), lon: String(longitude), page: pageCount, completion: {data,error in
            self.photos = data
            
            DispatchQueue.main.async {
                if error != nil {
                    self.showFailedMessage(title: "Error Loading Photos", message: error?.localizedDescription ?? "Something went wrong")
                }
                
                self.prepareUI()
                self.photoCollectionView.reloadData()
            }
        })
    }
        
    @IBAction func loadNewCollection(_ sender: Any) {
        page += 1
        showLoadingUI(isLoading: true)
        fetchPhotos(pageCount: page)
    }
    
    private func showLoadingUI(isLoading: Bool) {
        newCollectionBtn.isEnabled = !isLoading
        activityIndicator.isHidden = !isLoading
        
        if isLoading {
            newCollectionBtn.alpha = 0.5
            activityIndicator.startAnimating()
        } else {
            newCollectionBtn.alpha = 1
            activityIndicator.stopAnimating()
        }
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
                if error != nil {
                    self.showFailedMessage(title: "Error Loading Photos", message: error?.localizedDescription ?? "Something went wrong")
                }
                return
            }
            let image = UIImage(data: data)
            cell.cellImageView.image = image
            cell.setNeedsLayout()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        photos.remove(at: indexPath.row)
        photoCollectionView.reloadData()
    }
}
