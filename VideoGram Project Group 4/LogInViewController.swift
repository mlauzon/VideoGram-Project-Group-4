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
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    
    @IBAction func userLogin(_ sender: UIButton) {
        let usernameInput = usernameTextField.text!
        let passwordInput = passwordTextField.text!
        
        if UserBase.shared.testCKConnection() {
            if UserBase.shared.verifyUser(username: usernameInput) == .UsernameExists {
                let signingUserIn = UserBase.shared.login(username: usernameInput, password: passwordInput)
                if signingUserIn == .SuccessfulLogin {
                    //Popup notification - Login Successful
                    popUpNotification(string: LoginSuccessful)
                }
                else {
                    //Popup notification - incorrect password
                    popUpNotification(string: IncorrectPassword)
                }
            }
            else {
                //Popup notification- User DNE
                popUpNotification(string: UserNameDoesNotExist)
            }
        }
        else {
            //Popup notification- not connected to Cloud Server
            popUpNotification(string: CloudConnectionError)
        }
    }
    
    @IBAction func userSignUp(_ sender: UIButton) {
        let usernameInput = usernameTextField.text!
        let passwordInput = passwordTextField.text!
        
        if UserBase.shared.testCKConnection() {
            if UserBase.shared.verifyUser(username: usernameInput) == .UsernameDoesNotExist {
                UserBase.shared.addUser(username: usernameInput, password: passwordInput)
                //Popup notification - Account is created, try logging in now
                popUpNotification(string: CreatingAccount)
            }
            else {
                //Popup notification - Username already exists
                popUpNotification(string: UserNameAlreadyExists)
            }
        }
        else {
            //Popup notification - not connected to cloud server
            popUpNotification(string: CloudConnectionError)
        }
    }
    
    func popUpNotification(string: String) {
        let popup = UIAlertController(title: "Error", message: string, preferredStyle: UIAlertControllerStyle.alert)
        popup.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(popup, animated: true, completion:nil)
    }
    
    let UserNameAlreadyExists = "Username Already Exists"
    let UserNameDoesNotExist = "Username Does Not Exist"
    let IncorrectPassword = "Incorrect Password"
    let LoginSuccessful = "Logging user in..."
    let CreatingAccount = "Created Account. Please log in."
    let CloudConnectionError = "Cannot connect to CKDB"
    
    //TODO
    //    func goToHomePage() {
    //        //Moves to homepage after successful login
    //    }
    //
    //    func goToLoginPage() {
    //        //moves back to login page after unsuccessful login, or successful sign up
    //    }
    
    
}
