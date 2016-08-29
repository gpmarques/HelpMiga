//
//  DataService.swift
//  HelpMiga
//
//  Created by Guilherme Marques on 8/17/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class DataService {
    
    let ref = FIRDatabase.database().reference()
    let auth = FIRAuth.auth()
    let storage = FIRStorage.storage().referenceForURL("gs://help-miga.appspot.com")
    
    func getRTDBSingleton() -> FIRDatabaseReference {
        return ref
    }
    
    func getAuthSingleton() -> FIRAuth {
        return auth!
    }
}
