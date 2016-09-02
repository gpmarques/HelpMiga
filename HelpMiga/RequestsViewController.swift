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
            
            if uid != currentUserID && helped {
                
                let user = UserSOS(uid: uid, name: name, lat: lat, long: long, sosDate: sosDate, helped: helped)
                self.requestingHelp.append(user)
                self.populateView(uid, name: name, lat: lat, long: long)
                
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
