//
//  RequestsViewController.swift
//  HelpMiga
//
//  Created by Priscila Rosa on 8/9/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import UIKit
import MapKit

class RequestsViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var requestsBG: UIImageView!
    @IBOutlet weak var requestedHelpImageView: UIImageView!
    @IBOutlet weak var requestedHelpName: UILabel!
    @IBOutlet weak var requestedHelpDistance: UILabel!
    @IBOutlet weak var requestedHelpMapView: MKMapView!
    @IBOutlet weak var requestView: UIView!
    @IBOutlet weak var noRequestsLabel: UILabel!
    @IBOutlet weak var logo: UIImageView!
    
    var userDAO: UserDAO!
    var requestingHelp: [UserSOS] = []
    var destination: MKMapItem?

    @IBAction func callRequestedHelpButton(sender: AnyObject) {
    }
    
    @IBAction func goingButton(sender: AnyObject) {
        
        guard let image = UIImage(named: "goingSelected") else {
            print("Image Not Found")
            return
        }
        sender.setBackgroundImage(image, forState: UIControlState.Normal)
        let ref = userDAO.getRTDBSingleton()
        let currentUserID = userDAO.getCurrentUser()?.uid
        
        ref.child("users").child(currentUserID!).observeSingleEventOfType(.Value, withBlock: { snapshot in
        
            let rescuerName = snapshot.value!["username"] as! String
            let rescuerLat = snapshot.value!["lat"] as! Double
            let rescuerLong = snapshot.value!["long"] as! Double
            let rescuerCel = snapshot.value!["cel"] as! String
            let queueTop = self.requestingHelp.removeAtIndex(0)
            let name = queueTop.name
            let uid = queueTop.uid
            let sosDate = queueTop.sosDate
            
            let rescuerKey = uid!+name!+sosDate
            
            let rescuerDic = ["username": String(rescuerName),
                              "lat": Double(rescuerLat),
                              "long": Double(rescuerLong),
                              "cel": String(rescuerCel),
                              "uid": String(currentUserID)]
            
            ref.child("rescuer").child(rescuerKey).setValue(rescuerDic)
            
        })

    }

    @IBAction func rejectRequestButton(sender: AnyObject) {
        requestView.hidden = true
        noRequestsLabel.hidden = false
        logo.hidden = false
    }
    
    private func observeSOS() {
        let ref = userDAO.getRTDBSingleton()
        let sosQuery = ref.child("sos")
        let currentUserID = userDAO.getCurrentUser()?.uid
        sosQuery.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            let uid = snapshot.value!["uid"] as! String
            let name = snapshot.value!["username"] as! String
            let lat = snapshot.value!["lat"] as! Double
            let long = snapshot.value!["long"] as! Double
            let sosDate = snapshot.value!["sosDate"] as! String
            let helped = snapshot.value!["helped"] as! Bool
            
            if uid != currentUserID && !helped {
                
                print("*** ENTREI ***")
                let user = UserSOS(uid: uid, name: name, lat: lat, long: long, sosDate: sosDate, helped: helped)
                self.requestingHelp.append(user)
                self.populateView(uid, name: name, lat: lat, long: long)
                
                self.requestView.hidden = false
                self.requestsBG.hidden = false
                self.requestedHelpMapView.hidden = false
                self.requestedHelpDistance.hidden = false
                self.requestedHelpImageView.hidden = false
                self.requestedHelpName.hidden = false
                
                self.noRequestsLabel.hidden = true
                self.logo.hidden = true
                
            }
            
        })
    }
    
    private func checkHelper() {
        
    }
    
    private func populateView(id: String, name: String, lat: Double, long: Double) {
        
        requestedHelpName.text = name
        let storage = self.userDAO.storage
        let selfieRef = storage.child(name+id+"/selfie.jpg")
        selfieRef.dataWithMaxSize(2 * 1024 * 1024, completion: { (data, error) in
            
            if error != nil {
                print("*** \(error?.localizedDescription) ***")
                print ("ERRO DOWNLOAD<<<<<<<<<<<<<<<<<<<<<<<<<<")
            } else {
                self.requestedHelpImageView.image = UIImage(data: data!)
            }
        })
        
        guard let sourceLat = User.currentUser.lat else { return }
        guard let sourceLong = User.currentUser.long else { return }
        
        getDirections(sourceLat , sourceLong: sourceLong, destinationLat: lat, destinationLong: long)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //comentar as 3 linhas abaixo pra aparecer a view do request
        requestView.hidden = true
        noRequestsLabel.hidden = false
        logo.hidden = false

        requestedHelpImageView.layer.cornerRadius = requestedHelpImageView.frame.size.width/2
        requestedHelpImageView.clipsToBounds = true
        requestedHelpImageView.layer.borderWidth = 3
        requestedHelpImageView.layer.borderColor = UIColor.whiteColor().CGColor
        requestedHelpMapView.layer.cornerRadius = 10
        requestedHelpMapView.clipsToBounds = true
        
        userDAO = UserDAO.getSingleton()
        observeSOS()
        
        requestedHelpMapView.showsUserLocation = true
        requestedHelpMapView.delegate = self
        
        guard let lat = User.currentUser.lat else { return }
        guard let long = User.currentUser.long else { return }
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)
        requestedHelpMapView.setRegion(region, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDirections(sourceLat: Double, sourceLong: Double, destinationLat: Double, destinationLong: Double) {
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(sourceLat, sourceLong), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(destinationLat,destinationLong), addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .Walking
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler ({
            (response: MKDirectionsResponse?, error: NSError?) in
            
            if error == nil {
                let directionsResponse = response
                let route = directionsResponse!.routes.last! as MKRoute
                let distance = route.distance
                let time = route.expectedTravelTime
                
                self.requestedHelpDistance.text = "She's \(time / 60) minutes from you"
                
                print("DISTANCIA: \(distance)")
                
                self.requestedHelpMapView.addOverlay(route.polyline, level: MKOverlayLevel.AboveRoads)
                
            } else {
                print(">>>>ERRO ROTA<<<")
                print(error)
            }
        })
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        
        if overlay is MKPolyline {
//            polylineRenderer.lineDashPattern = [14,10,6,10,4,10]
            
            polylineRenderer.strokeColor = UIColor(red: 233, green: 30, blue: 64, alpha: 1.00)
            polylineRenderer.lineWidth = 3
            return polylineRenderer
        }
        return polylineRenderer
    }
    
//    func showRoute(response: MKDirectionsResponse) {
//        
//        for route in response.routes {
//            
//            requestedHelpMapView.addOverlay(route.polyline,
//                                level: MKOverlayLevel.AboveRoads)
//            
//            for step in route.steps {
//                print(step.instructions)
//            }
//        }
//        let userLocation = requestedHelpMapView.userLocation
//        let region = MKCoordinateRegionMakeWithDistance(
//            userLocation.location!.coordinate, 2000, 2000)
//        
//        requestedHelpMapView.setRegion(region, animated: true)
//    }
    
//    func mapView(mapView: MKMapView, rendererForOverlay
//        overlay: MKOverlay) -> MKOverlayRenderer {
//        let renderer = MKPolylineRenderer(overlay: overlay)
//        
//        renderer.strokeColor = UIColor.blueColor()
//        renderer.lineWidth = 5.0
//        return renderer
//    }


}
