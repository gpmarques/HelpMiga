//
//  SavePictures.swift
//  HelpMiga
//
//  Created by Priscila Rosa on 8/10/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import Foundation
import UIKit

class SavePhotos {
    
    static var savePhotos = SavePhotos()
    
    static func getSPSingleton() -> SavePhotos {
        return savePhotos
    }
    
    var imagesDirectoryPath:String = ""
    
    func createImageFolder() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        // Get the Document directory path
        let documentDirectorPath:String = paths[0]
        // Create a new path for the new images folder
        imagesDirectoryPath = documentDirectorPath.stringByAppendingString("/ImagePicker")
        var objcBool:ObjCBool = true
        let isExist = NSFileManager.defaultManager().fileExistsAtPath(imagesDirectoryPath, isDirectory: &objcBool)
        // If the folder with the given path doesn't exist already, create it
        if isExist == false{
            do{
                try NSFileManager.defaultManager().createDirectoryAtPath(imagesDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            }catch{
                print("Something went wrong while creating a new folder")
            }
        }
    }
    
    func saveLocally(finalImage: UIImage){
        var imagePath = NSDate().description
        imagePath = imagePath.stringByReplacingOccurrencesOfString(" ", withString: "")
        imagePath = imagesDirectoryPath.stringByAppendingString("/\(imagePath).png")
        
        let data = UIImagePNGRepresentation(finalImage)
        NSFileManager.defaultManager().createFileAtPath(imagePath, contents: data, attributes: nil)
        
    }
    
}
