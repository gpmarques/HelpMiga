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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
