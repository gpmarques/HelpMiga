//
//  AcceptedRequestCell.swift
//  HelpMiga
//
//  Created by Priscila Rosa on 8/13/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import UIKit

class AcceptedRequestCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var whiteView: UIView!
    
    @IBAction func callButton(sender: AnyObject) {
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