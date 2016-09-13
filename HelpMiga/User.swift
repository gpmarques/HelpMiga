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
    var lat, long: Double?
    var helped: Bool?
    static var currentUser: User?
        
    init(uid: String, name: String, email: String, cel: String, lat: Double, long: Double) {
        
        self.uid = uid
        self.name = name
        self.email = email
        self.cel = cel
        self.lat = lat
        self.long = long
        
    }
    
    init(uid: String, name: String, lat: Double, long: Double, helped: Bool) {
        
        self.name = name
        self.lat = lat
        self.long = long
        self.uid = uid
        self.helped = helped
        
    }
    
    init(uid: String, name: String, lat: Double, long: Double, cel: String) {
        
        self.name = name
        self.lat = lat
        self.long = long
        self.uid = uid
    }
    
    static func getCurrentUser() -> User {
        return currentUser!
    }
}