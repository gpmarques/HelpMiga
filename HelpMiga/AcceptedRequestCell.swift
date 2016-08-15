//
//  AcceptedRequestCell.swift
//  HelpMiga
//
//  Created by Priscila Rosa on 8/13/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import UIKit

class AcceptedRequestCell: UICollectionViewCell {
    
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var acceptedRequestImageView: UIImageView!
    @IBOutlet weak var acceptedRequestName: UILabel!
    @IBOutlet weak var acceptedRequestDistance: UILabel!
    @IBAction func acceptedRequestCallButton(sender: AnyObject) {
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        
//        image.layer.cornerRadius = image.frame.size.width / 2
//        image.clipsToBounds = true
//        image.layer.borderWidth = 3
//        image.layer.borderColor = UIColor.whiteColor().CGColor
//        whiteView.layer.cornerRadius = 10
//    }
}