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
    var requestingHelp: [User]?
    
    var destination: MKMapItem?

    @IBAction func callRequestedHelpButton(sender: AnyObject) {
    }
    
    @IBAction func goingButton(sender: AnyObject) {
        
        guard let image = UIImage(named: "goingSelected") else {
            print("Image Not Found")
            return
        }
        sender.setBackgroundImage(image, forState: UIControlState.Normal)
    }

    @IBAction func rejectRequestButton(sender: AnyObject) {
        requestView.hidden = true
        noRequestsLabel.hidden = false
        logo.hidden = false
        
    }
    
    private func observeSOS() {
        
        let ref = userDAO.getRTDBSingleton()
        let sosQuery = ref.child("sos")
        let uid = userDAO.getCurrentUser()?.uid
        
        sosQuery.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            let name = snapshot.value!["username"] as! String
            let lat = snapshot.value!["lat"] as! Double
            let long = snapshot.value!["long"] as! Double
            let helped = snapshot.value!["helped"] as! Bool
            
            
            let user = User(uid: uid!, name: name, lat: lat, long: long, helped: helped)
            self.requestingHelp?.append(user)
            self.populateView(uid!, name: name, lat: lat, long: long)
            
            self.requestsBG.hidden = false
            self.requestedHelpMapView.hidden = false
            self.requestedHelpDistance.hidden = false
            self.requestedHelpImageView.hidden = false
            self.requestedHelpName.hidden = false
            
            self.noRequestsLabel.hidden = true
            self.logo.hidden = true
            
        })
    }
    
    private func checkHelper() {
        
    }
    
    private func populateView(id: String, name: String, lat: Double, long: Double) {
        
        requestedHelpName.text = name
        guard let data = self.userDAO.downloadImageData(id, name: name) else { return }
        let image = UIImage(data: data)
        requestedHelpImageView.image = image
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //comentar as 3 linhas abaixo pra aparecer a view do request
//        requestView.hidden = true
//        noRequestsLabel.hidden = false
//        logo.hidden = false

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
        self.getDirections()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDirections() {
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(-22.9760044, -43.228514700000005), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(-22.975261, -43.22858239999999), addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .Walking
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler ({
            (response: MKDirectionsResponse?, error: NSError?) in
            
            if error == nil {
                let directionsResponse = response
                let route = directionsResponse!.routes.last! as MKRoute
                let distance = route.distance
                print("DISTANCIA: \(distance)")
            } else {
                print(">>>>ERRO ROTA<<<")
                print(error)
            }
        })
        
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
