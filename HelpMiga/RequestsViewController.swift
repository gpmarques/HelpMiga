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
    
    @IBAction func callRequestedHelpButton(sender: AnyObject) {
    }
    
    @IBAction func goingButton(sender: AnyObject) {
    }

    @IBAction func rejectRequestButton(sender: AnyObject) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        requestsBG.layer.cornerRadius = 50
        requestsBG.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
