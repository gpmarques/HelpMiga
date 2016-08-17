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
    var askedHelp = false

    //CONSTRAINTS
    @IBOutlet weak var buttonCenterX: NSLayoutConstraint!
    @IBOutlet weak var buttonY: NSLayoutConstraint!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonWidth: NSLayoutConstraint!
    @IBOutlet weak var mapViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var findingGirlsLabel: UILabel!
    @IBOutlet weak var askHelpLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var girl: UIImageView!
    @IBOutlet weak var closeRequestOutlet: UIButton!
    @IBOutlet weak var askHelpOutlet: UIButton!
    
    
    
    @IBAction func askHelpButton(sender: AnyObject) {
        interfaceChangesWhenAskHelpClicked(sender)

    }
    
    @IBAction func closeRequestButton(sender: AnyObject) {
        interfaceChangesWhenCloseRequestClicked(sender)

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
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AcceptedRequestIdentifier", forIndexPath: indexPath) as! AcceptedRequestCell
        
        cell.acceptedRequestImageView.layer.cornerRadius = cell.acceptedRequestImageView.frame.size.width / 2
        cell.acceptedRequestImageView.clipsToBounds = true
        cell.acceptedRequestImageView.layer.borderWidth = 3
        cell.acceptedRequestImageView.layer.borderColor = UIColor.whiteColor().CGColor
        cell.whiteView.layer.cornerRadius = 10
        
        //        mudar pras infos das pessoas que aceitaram o pedido
        cell.acceptedRequestName.text = "Fulana"
        cell.acceptedRequestImageView.image = UIImage(named: "girl2")
        cell.acceptedRequestDistance.text = "5 minutes from you"
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
            
            //falta diminuir a altura do mapview
            
            if self.askedHelp == false {
                
                //            self.buttonCenterX.constant = 200.0
                //            self.buttonY.constant = 400
                //            self.view.layoutIfNeeded()
                
                UIView.animateWithDuration(Double(0.5), animations: {
                    self.findingGirlsLabel.alpha = 1
                    self.askHelpLabel.alpha = 0
                    self.buttonCenterX.constant = -110
                    self.buttonY.constant = 20
                    self.buttonWidth.constant = -60
                    self.buttonHeight.constant = -60
                    self.view.layoutIfNeeded()
                })
                
                self.acceptedRequestCollectionView.hidden = false
                self.girl.hidden = true
                self.closeRequestOutlet.hidden = false
                guard let image = UIImage(named: "request_sent_bubble_round") else {
                    print("Image Not Found")
                    return
                }
                button.setBackgroundImage(image, forState: UIControlState.Normal)
                self.askedHelp = true
            } else {
                
                UIView.animateWithDuration(Double(0.5), animations: {
                    self.findingGirlsLabel.alpha = 0
                    self.askHelpLabel.alpha = 1
                    self.buttonCenterX.constant += 110
                    self.buttonY.constant = 100
                    self.buttonWidth.constant += 60
                    self.buttonHeight.constant += 60
                    self.view.layoutIfNeeded()
                })
                guard let image = UIImage(named: "ask_help_bubble_round") else {
                    print("Image Not Found")
                    return
                }
                button.setBackgroundImage(image, forState: UIControlState.Normal)
                self.askedHelp = false
                
                self.girl.hidden = false
                self.acceptedRequestCollectionView.hidden = true
                self.closeRequestOutlet.hidden = true
            }
        })
    }
    
    func interfaceChangesWhenCloseRequestClicked(button: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            
            UIView.animateWithDuration(Double(0.5), animations: {
                self.findingGirlsLabel.alpha = 0
                self.askHelpLabel.alpha = 1
                self.buttonCenterX.constant += 110
                self.buttonY.constant = 100
                self.buttonWidth.constant += 60
                self.buttonHeight.constant += 60
                self.view.layoutIfNeeded()
            })
            guard let image = UIImage(named: "ask_help_bubble_round") else {
                print("Image Not Found")
                return
            }
            self.askHelpOutlet.setBackgroundImage(image, forState: UIControlState.Normal)
            
            self.girl.hidden = false
            self.acceptedRequestCollectionView.hidden = true
            self.closeRequestOutlet.hidden = true
            
            self.askedHelp = false
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

