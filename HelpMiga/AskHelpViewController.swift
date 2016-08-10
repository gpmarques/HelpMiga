//
//  AskHelpViewController.swift
//  HelpMiga
//
//  Created by Priscila Rosa on 8/9/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AskHelpViewController: UIViewController, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    let initialLocation = CLLocation()

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var girl: UIImageView!
    
    @IBOutlet weak var closeRequestOutlet: UIButton!
    
    @IBOutlet weak var askHelpOutlet: UIButton!
    
    @IBAction func askHelpButton(sender: AnyObject) {
        acceptedRequestCollectionView.hidden = false
        girl.hidden = true
        closeRequestOutlet.hidden = false
        askHelpOutlet.imageView?.image = UIImage(named: "request_sent_bubble_round")
        
    }
    @IBAction func closeRequestButton(sender: AnyObject) {
    }
  
    @IBOutlet weak var acceptedRequestCollectionView: UICollectionView!
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }

    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //mudar pro numero de pessoas que aceitaram o pedido
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : AcceptedRequestCell = collectionView.dequeueReusableCellWithReuseIdentifier("AcceptedRequestIdentifier", forIndexPath: indexPath) as! AcceptedRequestCell
        
        //mudar pras infos das pessoas que aceitaram o pedido
        cell.name.text = "Priscila"
        cell.image.image = UIImage(named: "isa")
        cell.distance.text = "3 minutes from you."
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier:"SectionHeader", forIndexPath: indexPath) as UICollectionReusableView
        
        return supplementaryView
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let height = 80
        return CGSizeMake(collectionView.bounds.size.width - 12, CGFloat(height))
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationAuthorizationStatus()
        //        centerMapOnLocation(initialLocation)
        
        mapView.showsUserLocation = true
        
        let nib = UINib(nibName: "AcceptedRequestCell", bundle: nil)
        self.acceptedRequestCollectionView.registerNib(nib, forCellWithReuseIdentifier: "AcceptedRequestIdentifier")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

