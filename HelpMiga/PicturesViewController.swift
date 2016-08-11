//
//  PicturesViewController.swift
//  HelpMiga
//
//  Created by Priscila Rosa on 8/9/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import UIKit

class PicturesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var savePhotos = SavePhotos.getSPSingleton()
    var images:[UIImage] = []
    var titles:[String]!

    @IBOutlet weak var picturesCollectionView: UICollectionView!
    
    @IBAction func takePictureButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.Camera;
            picker.allowsEditing = false
            
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        savePhotos.saveLocally(image)
        self.dismissViewControllerAnimated(true, completion: nil)
        refreshCollection()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //trocar pras fotos
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PicturesCellIdentifier", forIndexPath: indexPath) as! PicturesCell
        
//        cell.pictureImageView.image = self.userPictures[indexPath.row]
        cell.pictureImageView?.image = images[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = collectionView.bounds.size.width / 2 - 20
        return CGSizeMake(width, width)
    }
    
    func refreshCollection(){
        
        do {
            print (">>>>>>>ENTROU NO REFRESH<<<<<<<<<")
            images.removeAll()
            
            titles = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(savePhotos.imagesDirectoryPath)
            for image in titles {
                let data = NSFileManager.defaultManager().contentsAtPath(savePhotos.imagesDirectoryPath.stringByAppendingString("/\(image)"))
                if data != nil {
                    guard let image = UIImage(data: data!) else { break }
                    images.insert(image, atIndex: 0)
                }
            }
            self.picturesCollectionView.reloadData()
        } catch {
            print("Error")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savePhotos.createImageFolder()
        picturesCollectionView.delegate = self
        refreshCollection()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
