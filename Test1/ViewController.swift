//
//  ViewController.swift
//  Test1
//
//  Created by Turker Kizilcik on 13.08.2023.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var debugLabel: UILabel!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debugLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let storedPassword = UserDefaults.standard.object(forKey: "password")
        
        if storedPassword == nil {
            signInButton.isHidden = true
            //welcomeLabel.numberOfLines = 3
            welcomeLabel.text = "Welcome, enter a password and sign up"
        } else {
            signUpButton.isHidden = true
            //welcomeLabel.numberOfLines = 3
            welcomeLabel.text = "Welcome, enter your password and sign in"
        }
    }
    
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        
        let storedPassword = UserDefaults.standard.object(forKey: "password")
        
        if let storedPasswordAsString = storedPassword as? String {
            if storedPasswordAsString == passwordTextField.text {
                performSegue(withIdentifier: "toList", sender: nil)
            } else {
                makeAlert(titleInput: "Passwords don't match", messageInput: "Enter your password again.")
            }
        }
        
    }
    
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        let storedPassword = UserDefaults.standard.object(forKey: "password")
        
        if (passwordTextField.text?.count ?? 0) >= 4 {
            if storedPassword == nil {
                UserDefaults.standard.set(passwordTextField.text, forKey: "password")
                makeAlert(titleInput: "User is created!", messageInput: "You can sign in now.")
                signInButton.isHidden = false
                signUpButton.isHidden = true
                welcomeLabel.text = "Welcome, enter your password and sign in"
            } else {
                makeAlert(titleInput: "You already have signed up!", messageInput: "Sign in with your password.")
            }
        } else {
            makeAlert(titleInput: "Password can't be shorter than 4 characters!", messageInput: "Try another password.")
        }
        
        //let passwordFromTextField = UserDefaults.standard.object(forKey: "password")
        //if let storedPassword = passwordFromTextField as? String {
        //   debugLabel.text = storedPassword
        //}
    }
    
    func makeAlert(titleInput: String, messageInput : String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
        
}

