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

class AskHelpViewController: UIViewController, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?

    @IBOutlet weak var buttonCenterX: NSLayoutConstraint!
    @IBOutlet weak var buttonY: NSLayoutConstraint!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var girl: UIImageView!
    @IBOutlet weak var closeRequestOutlet: UIButton!
    @IBOutlet weak var askHelpOutlet: UIButton!
    
    @IBAction func askHelpButton(sender: AnyObject) {
        interfaceChangesWhenAskHelpClicked(sender)

    }
    
    @IBAction func closeRequestButton(sender: AnyObject) {
        acceptedRequestCollectionView.hidden = true
        closeRequestOutlet.hidden = true
        guard let image = UIImage(named: "ask_help_bubble_round") else {
            print("Image Not Found")
            return
        }
        askHelpOutlet.setBackgroundImage(image, forState: UIControlState.Normal)
    }
  
    @IBOutlet weak var acceptedRequestCollectionView: UICollectionView!

    
    //MARK: - Location Manager
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
        case .NotDetermined:
            print("NotDetermined")
        case .Restricted:
            print("Restricted")
        case .Denied:
            print("Denied")
        case .AuthorizedAlways:
            print("AuthorizedAlways")
        case .AuthorizedWhenInUse:
            print("AuthorizedWhenInUse")
            locationManager!.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.first!
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
        mapView.setRegion(coordinateRegion, animated: true)
        locationManager?.stopUpdatingLocation()
        locationManager = nil
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to initialize GPS: ", error.description)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //mudar pro numero de pessoas que aceitaram o pedido
        return 3
    }
    
    //MARK: - Collection View
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : AcceptedRequestCell = collectionView.dequeueReusableCellWithReuseIdentifier("AcceptedRequestIdentifier", forIndexPath: indexPath) as! AcceptedRequestCell
        
        //mudar pras infos das pessoas que aceitaram o pedido
        cell.name.text = "Fulana"
        cell.image.image = UIImage(named: "girl2")
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
    
    //MARK: - Interface changes
    
    func interfaceChangesWhenAskHelpClicked(button: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            
//            self.buttonCenterX.constant = 200.0
//            self.buttonY.constant = 400
//            self.view.layoutIfNeeded()
            
//            UIView.animateWithDuration(Double(0.5), animations: {
//                self.buttonCenterX.constant = -100
//                self.buttonY.constant = -20
//                self.view.layoutIfNeeded()
//            })
            
            self.acceptedRequestCollectionView.hidden = false
            self.girl.hidden = true
            self.closeRequestOutlet.hidden = false
            guard let image = UIImage(named: "request_sent_bubble_round") else {
                print("Image Not Found")
                return
            }
            button.setBackgroundImage(image, forState: UIControlState.Normal)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        
        if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            locationManager!.startUpdatingLocation()
            mapView.showsUserLocation = true
        } else {
//            locationManager!.requestWhenInUseAuthorization()
            locationManager!.requestAlwaysAuthorization()
        }
        
        
        
        let nib = UINib(nibName: "AcceptedRequestCell", bundle: nil)
        self.acceptedRequestCollectionView.registerNib(nib, forCellWithReuseIdentifier: "AcceptedRequestIdentifier")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

