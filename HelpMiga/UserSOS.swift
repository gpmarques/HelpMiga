//
//  UserSOS.swift
//  HelpMiga
//
//  Created by Guilherme Marques on 9/1/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import Foundation

class UserSOS: User {
    
    var sosDate: String
    
    init(uid: String, name: String, lat: Double, long: Double, sosDate: String, helped: Bool) {
        self.sosDate = sosDate
        super.init(uid: uid, name: name, lat: lat, long: long, helped: helped)
    }
    
    
    
}