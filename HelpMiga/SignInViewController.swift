//
//  SignInViewController.swift
//  HelpMiga
//
//  Created by Priscila Rosa on 8/9/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import UIKit
import Firebase

extension UIViewController {
    func showAlert(title: String, msg: String, actionButton: String
        ){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: actionButton , style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

class SignInViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var botaoImagem:UIImageView = UIImageView()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var idImageView: UIImageView!
    @IBOutlet weak var selfieImageView: UIImageView!
    var myActivityIndicator: UIActivityIndicatorView!
    let userDAO = UserDAO.getSingleton()

    @IBAction func idButton(sender: AnyObject) {
        botaoImagem = idImageView
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            let idPicker = UIImagePickerController()
            idPicker.delegate = self
            idPicker.sourceType = UIImagePickerControllerSourceType.Camera;
            idPicker.allowsEditing = false
            
            self.presentViewController(idPicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func selfieButton(sender: AnyObject) {
        botaoImagem = selfieImageView
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            let selfiePicker = UIImagePickerController()
            selfiePicker.delegate = self
            selfiePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            selfiePicker.allowsEditing = false
            
            self.presentViewController(selfiePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func sendToApprovalButton(sender: AnyObject) {
        let username = nameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        let confPassword = repeatPasswordTextField.text
        
        if email != "" && password != "" && confPassword != "" && username != "" {
            
            if password == confPassword {
                myActivityIndicator.startAnimating()
                FIRAuth.auth()?.createUserWithEmail(email!, password: password!, completion: { user, error in
                    
                    if error != nil {
                        
                        if let errorCode = FIRAuthErrorCode(rawValue: error!.code) {
                            switch errorCode {
                            case .ErrorCodeInvalidCredential:
                                self.showAlert("Invalid Credentials!", msg: "Please, try again.", actionButton: "OK")
                            case .ErrorCodeNetworkError:
                                self.showAlert("Network Error!", msg: "An error occurred while attempting to contact the authentication server. Try again", actionButton: "OK")
                            case .ErrorCodeOperationNotAllowed:
                                self.showAlert("Bummer!", msg: "The administrator disabled sign in with the specified identity provider", actionButton: "OK")
                            case .ErrorCodeEmailAlreadyInUse:
                                self.showAlert("Oops!", msg: "The email used to attempt a sign up already exists. Please, try again", actionButton: "OK")
                            case .ErrorCodeInvalidEmail:
                                self.showAlert("Error", msg: "The email is invalid. Try again.", actionButton: "OK")
                            case .ErrorCodeTooManyRequests:
                                self.showAlert("Error", msg: "Too many requests were made to a serve method", actionButton: "OK")
                            case .ErrorCodeWeakPassword:
                                self.showAlert("Error", msg: "Your password must be at least 6 characters long. Try again.", actionButton: "OK")
                                
                                
                            default:
                                self.showAlert("Ups!", msg: "An error occur. Please, try again.", actionButton: "OK")
                            }
                        }
                    } else if user != nil {
                        // creating user in the realtime database and sending email verification
                        let uid = user!.uid
                        self.userDAO.createUser(uid, name: username!, email: email!, cel: "0000-0000", lat: 0, long: 0, approved: false)
                        user!.sendEmailVerificationWithCompletion(nil)
                        
                        // uploading the id and selfie picture
                        let dataIDImage = UIImageJPEGRepresentation(self.idImageView.image!, 1.0)
                        let dataSelfieImage = UIImageJPEGRepresentation(self.selfieImageView.image!, 1.0)
                        let upload = self.userDAO.uploadImage(dataIDImage!, userID: uid, userName: username!, imageName: "id")
                        let upload2 = self.userDAO.uploadImage(dataSelfieImage!, userID: uid, userName: username!, imageName: "selfie")
                        if upload && upload2 {
                            print("*** UPLOADED ***")
                        } else {
                            print("*** UPLOAD ERROR ***")
                        }
                    
                        let alert = UIAlertController(title: "Great!", message: "You have successfully signed up.", preferredStyle: .Alert)
                        let action = UIAlertAction(title: "OK" , style: .Default, handler: nil)
                        alert.addAction(action)
                        self.myActivityIndicator.stopAnimating()
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    
                })
                
            } else {
                self.showAlert("Password Mismatch", msg: "The passwords you've entered do not match. Please, try again", actionButton: "OK")
            }
            
        } else {
            self.showAlert("Empty field", msg: "In order to sign up all fields must be filled. Please, try again", actionButton: "OK")
        }
    }
    
    func alert(userMessage: String, title: String){
        
        let meuAlerta = UIAlertController(title: title, message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        meuAlerta.addAction(okButton)
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(meuAlerta, animated: true, completion: nil)
        })
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {

        botaoImagem.image = image
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.repeatPasswordTextField.delegate = self
        myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        myActivityIndicator.center = CGPoint(x: view.center.x , y: view.frame.height*0.429348)
        view.addSubview(myActivityIndicator)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
