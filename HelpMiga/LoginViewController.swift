//
//  ViewController.swift
//  HelpMiga
//
//  Created by Guilherme Marques on 8/8/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    var myActivityIndicator: UIActivityIndicatorView!

    @IBAction func signInButton(sender: AnyObject) {
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        let email = emailTextField.text
        let password = passwordTextField.text
        myActivityIndicator.startAnimating()
        FIRAuth.auth()?.signInWithEmail(email!, password: password!, completion: { user, error in
            if error != nil {
                self.myActivityIndicator.stopAnimating()
                if let errorCode = FIRAuthErrorCode(rawValue: error!.code) {
                    switch errorCode {
                    case .ErrorCodeWrongPassword:
                        self.showAlert("You have entered an invalid username or password.", msg: "Please, try again.", actionButton: "OK")
                    case .ErrorCodeUserDisabled:
                        self.showAlert("This account is disabled", msg: "Please try a different account.", actionButton: "OK")
                    case .ErrorCodeNetworkError:
                        self.showAlert("Network Error!", msg: "An error occurred while attempting to contact the authentication server. Try again", actionButton: "OK")
                    case .ErrorCodeTooManyRequests:
                        self.showAlert("Error", msg: "Please, try again.", actionButton: "OK")
                    default:
                        self.showAlert("Ups!", msg: "An error occurred. Please, try again.", actionButton: "OK")
                    }
                }
            } else if user != nil {
                self.myActivityIndicator.stopAnimating()
                self.performSegueWithIdentifier("loginSegue", sender: sender)
            }
        })
    }
  
//    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
//
//        if identifier == "loginSegue" {
//            if emailTextField.text!.isEmpty == true || passwordTextField.text!.isEmpty == true {
//                return false
//            } else {
//                //fazer um if pra ver se o email e senha combinam
//                return true
//            }
//        } else {
//            return true
//        }
//    }
    
    // MARK: DISMISS KEYBOARD
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: TEXT FIELD + SCROLL VIEW
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == passwordTextField){
            scrollView.setContentOffset(CGPointMake(0, 80), animated: true)
        } else {
            scrollView.setContentOffset(CGPointMake(0, 20), animated: true)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func notifyUser(title: String, message: String) -> Void {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .Cancel, handler: nil)
        
        alert.addAction(cancelAction)
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alert, animated: true,
                completion: nil)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        myActivityIndicator.center = CGPoint(x: view.center.x , y: view.frame.height*0.429348)
        view.addSubview(myActivityIndicator)
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if user != nil {
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            } else {
                // No user is signed in.
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

