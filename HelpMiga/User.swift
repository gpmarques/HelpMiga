//
//  User.swift
//  HelpMiga
//
//  Created by Guilherme Marques on 8/24/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import Foundation

class User {
    
    var uid, name, email, cel: String?
    var lat, long, time: Double?
    var approved, helped: Bool?
    
    init(name: String, email: String, cel: String, lat: Double, long: Double, approved: Bool) {
        
        self.name = name
        self.email = email
        self.cel = cel
        self.lat = lat
        self.long = long
        self.approved = approved
    }
    
    init(uid: String, name: String, lat: Double, long: Double, time: Double, helped: Bool) {
        
        self.name = name
        self.lat = lat
        self.long = long
        self.uid = uid
        self.helped = helped
        
    }
    
}