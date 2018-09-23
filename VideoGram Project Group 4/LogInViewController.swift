//
//  LogInViewController.swift
//  VideoGram Project Group 4
//
//  Created by student on 9/22/18.
//  Copyright © 2018 The-Windows-Specialists. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBOutlet var usernameTextField: UITextField! {
        didSet{
            textFieldNoEditing(usernameTextField)
        }
    }
    @IBOutlet var passwordTextField: UITextField! {
        didSet{
            textFieldNoEditing(passwordTextField)
        }
    }
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    
    @IBAction func userLogin(_ sender: UIButton) {
        let usernameInput = usernameTextField.text!
        let passwordInput = passwordTextField.text!
        
        if UserBase.CKUsers.testCKConnection() {
            if UserBase.CKUsers.verifyUser(username: usernameInput) == .UsernameExists {
                let signingUserIn = UserBase.CKUsers.login(username: usernameInput, password: passwordInput)
                if signingUserIn == .SuccessfulLogin {
                    //Popup notification - Login Successful
                    popUpNotification(title: LoginSuccessful, message: LoggingUserIn)
                }
                else {
                    //Popup notification - incorrect password
                    popUpNotification(title: Error, message: IncorrectPassword)
                }
            }
            else {
                //Popup notification- User DNE
                popUpNotification(title: Error, message: UserNameDoesNotExist)
            }
        }
        else {
            //Popup notification- not connected to Cloud Server
            popUpNotification(title: Error, message: CloudConnectionError)
        }
    }
    
    @IBAction func userSignUp(_ sender: UIButton) {
        let usernameInput = usernameTextField.text!
        let passwordInput = passwordTextField.text!
        
        if UserBase.CKUsers.testCKConnection() {
            if UserBase.CKUsers.verifyUser(username: usernameInput) == .UsernameDoesNotExist {
                UserBase.CKUsers.addUser(username: usernameInput, password: passwordInput)
                UserBase.CKUsers.saveUserBase()
                //Popup notification - Account is created, try logging in now
                popUpNotification(title: CreatedAccount, message: NewAccountSignIn)
            }
            else {
                //Popup notification - Username already exists
                popUpNotification(title: Error, message: UserNameAlreadyExists)
            }
        }
        else {
            //Popup notification - not connected to cloud server
            popUpNotification(title: Error, message: CloudConnectionError)
        }
    }
    
    func popUpNotification(title: String, message: String) {
        let popup = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        popup.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(popup, animated: true, completion:nil)
    }
    
    let Error = "Error"
    let UserNameAlreadyExists = "Username Already Exists"
    let UserNameDoesNotExist = "Username Does Not Exist"
    let IncorrectPassword = "Incorrect Password"
    let LoginSuccessful = "Login Successful"
    let LoggingUserIn = "Logging user in..."
    let CreatedAccount = "Created Account"
    let NewAccountSignIn = "Please log in."
    let CloudConnectionError = "Cannot connect to CKDB"
    
    func textFieldNoEditing(_ textfield: UITextField) {
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.spellCheckingType = .no
    }
    
    //TODO
    //    func goToHomePage() {
    //        //Moves to homepage after successful login
    //    }
    //
    //    func goToLoginPage() {
    //        //moves back to login page after unsuccessful login, or successful sign up
    //    }
    
    
}
