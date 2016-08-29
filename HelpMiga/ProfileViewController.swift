//
//  ProfileViewController.swift
//  HelpMiga
//
//  Created by Priscila Rosa on 8/9/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameTextfield: UITextField!
    @IBOutlet weak var profileEmailTextField: UITextField!
    @IBOutlet weak var profilePhoneTextField: UITextField!
    var userDAO = UserDAO.getSingleton()
    
    
    @IBAction func logOutButton(sender: AnyObject) {
        // segue para a tela de login
        let auth = userDAO.getAuthSingleton
        try! auth.signOut()
        
    }
    
    @IBAction func editProfilePhoto(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            let profilePicker = UIImagePickerController()
            profilePicker.delegate = self
            profilePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            profilePicker.allowsEditing = false
            
            self.presentViewController(profilePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        profileImageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        profileNameTextfield.delegate = self
        profileEmailTextField.delegate = self
        profilePhoneTextField.delegate = self
        
        guard let authUser = userDAO.getCurrentUser() else { print("*** NOT LOGGED IN ***"); return}
        let uid = authUser.uid
        
        userDAO.ref.child("users").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
            self.profileNameTextfield.text = snapshot.value!["username"] as? String
            self.profileEmailTextField.text = snapshot.value!["email"] as? String
            self.profilePhoneTextField.text = snapshot.value!["cel"] as? String
        
            let selfieRef = self.userDAO.storage.child(self.profileNameTextfield.text!+uid+"/"+"id.jpg")
            selfieRef.dataWithMaxSize(2 * 1024 * 1024, completion: { (data, error) in
                
                if error != nil {
                    print("*** \(error?.localizedDescription) ***")
                } else {
                    self.profileImageView.image = UIImage(data: data!)
                }
                
            })
            
            
        }) { (error) in
            print(error.localizedDescription)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
