//
//  SignInViewController.swift
//  HelpMiga
//
//  Created by Priscila Rosa on 8/9/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var botaoImagem:UIImageView = UIImageView()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var idImageView: UIImageView!
    @IBOutlet weak var selfieImageView: UIImageView!

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
        let userName = nameTextField.text
        let userEmail = emailTextField.text
        let userPassword = passwordTextField.text
        let repeatPassword = repeatPasswordTextField.text
        
        if userName?.isEmpty == true || userEmail?.isEmpty == true || userPassword?.isEmpty == true || repeatPassword?.isEmpty == true {
            alert ("Todos os campos devem ser preenchidos!", title: "Ops!")
            return
        }
        
        if userPassword != repeatPassword {
            alert ("As senhas não combinam", title: "Ops!")
            return
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
