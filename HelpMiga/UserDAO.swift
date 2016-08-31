//
//  UserDAO.swift
//  HelpMiga
//
//  Created by Guilherme Marques on 8/17/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseAuth

class UserDAO: DataService {

    private static let userDAO = UserDAO()
    
    private override init() {}
    
    // MARK: Create User in the RealTime Database
    
    func createUser(uid: String, name: String, email: String, cel: String, lat: Double, long: Double, approved: Bool) {
        let userDic = ["username": name, "email": email, "cel": cel, "lat": lat, "long": long, "approved": approved, "help": false]
        ref.child("users").child(uid).setValue(userDic)
    }
    
    // MARK: Delete User in the RealTime Database
    
    func deleteUser() {
        
        let user = getCurrentUser()
        
        user?.deleteWithCompletion { error in
            if error != nil {
                // An error happened.
            } else {
                // Account deleted.
            }
            
        }
    }
    
    // MARK: Get current user
    
    func getCurrentUser() -> FIRUser? {
        if let currentUser = auth!.currentUser {
            return currentUser
        } else {
            // No user is signed in.
            return nil
        }
    }
    
//    func getUserInfo() -> User {
//        
//        let currentUser = getCurrentUser()
//        let uid = currentUser?.uid
//        
//        ref.child("users").child(uid!).observeEventType(.Value, withBlock: {snapshot in
//            
//            let name = snapshot.value!["name"]
//            let lat = snapshot.value!["lat"]
//            let long = snapshot.value!["long"]
//            let cel = snapshot.value!["cel"]
//            
//
//
//        
//        })
//        
//    }
    
    func uploadImage(imageData: NSData, userID: String, userName: String, imageName: String) -> Bool {
        
        let mediaName = userName+userID+"/"+imageName+".jpg"
        let selfieRef = storage.child(mediaName)
        var upload = true
        
        _ = selfieRef.putData(imageData, metadata: nil) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
                upload = false
                guard let storageError = error else { return }
                guard let errorCode = FIRStorageErrorCode(rawValue: storageError.code) else { return }
                switch errorCode {
                case .ObjectNotFound:
                    // File doesn't exist
                    print("*** \(storageError.description) ***")
                    break
                    
                case .Unauthorized:
                    // User doesn't have permission to access file
                    print("*** \(storageError.description) ***")
                    break
                    
                case .Cancelled:
                    // User canceled the upload
                    print("*** \(storageError.description) ***")
                    break
                    
                case .QuotaExceeded:
                    // Firebase Quota exceeded
                    print("*** \(storageError.description) ***")
                    break
                    
                case .Unknown:
                    // Unknown error occurred, inspect the server response
                    print("*** \(storageError.description) ***")
                    break
                
                default:
                    print("*** \(storageError.description) ***")
                    break
                
                }
                
            }
        }
        return upload
    }
    
    func downloadImageData(uid: String, name: String) -> NSData? {
    
        var imageData: NSData?
        let selfieRef = storage.child(name+uid+"/"+"selfie.jpg")
        selfieRef.dataWithMaxSize(10 * 1024 * 1024, completion: { (data, error) in
            
            if error != nil {
                print("*** \(error?.localizedDescription) ***")
                print ("ERRO DOWNLOAD<<<<<<<<<<<<<<<<<<<<<<<<<<")
            } else {
                imageData = data
            }
        })
        
        if imageData != nil {
            return imageData
        } else {
            return nil
        }
        
    }
    
    func askHelp(uid: String, name: String, cel: String, lat: Double, long: Double) {
        
        let sosDate = Int(NSDate.timeIntervalSinceReferenceDate())
        let sosKey = name+uid+String(sosDate)
        let userDic = ["uid": uid,"username": name, "cel": cel, "lat": lat, "long": long, "helped": false]
        ref.child("sos").child(sosKey).setValue(userDic)
    }
    
    func finishRequest() {
    
    
    
    }
    
    // MARK: get userdao singleton
    
    static func getSingleton() -> UserDAO {
        return userDAO
    }
    
}
