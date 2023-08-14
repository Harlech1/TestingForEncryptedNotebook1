//
//  ViewController.swift
//  Test1
//
//  Created by Turker Kizilcik on 13.08.2023.
//

import UIKit
import Security

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
        
        let hasPassword = checkIfPasswordExists()
        
        passwordTextField.text = ""
                
        signUpButton.isHidden = hasPassword
        signInButton.isHidden = !hasPassword
    }
    
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        
        if let enteredPassword = passwordTextField.text {
                let query: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrAccount as String: "userPassword",
                    kSecReturnData as String: kCFBooleanTrue!,
                    kSecMatchLimit as String: kSecMatchLimitOne
                ]
                
                var item: CFTypeRef?
                let status = SecItemCopyMatching(query as CFDictionary, &item)
                
                if status == errSecSuccess, let passwordData = item as? Data, let password = String(data: passwordData, encoding: .utf8) {
                    if enteredPassword == password {
                        performSegue(withIdentifier: "toList", sender: nil)
                    } else {
                        makeAlert(titleInput: "Password doesn't match.", messageInput: "Try another password.")
                    }
                } else {
                    makeAlert(titleInput: "Error!", messageInput: "Restart your app and try again.")
                }
            }
        
    }
    
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        if (passwordTextField.text?.count ?? 0) >= 4 {
            if let password = passwordTextField.text {
                        let passwordData = password.data(using: .utf8)!
                        
                        let query: [String: Any] = [
                            kSecClass as String: kSecClassGenericPassword,
                            kSecAttrAccount as String: "userPassword",
                            kSecValueData as String: passwordData
                        ]
                        
                        let status = SecItemAdd(query as CFDictionary, nil)
                        
                        if status == errSecSuccess {
                            makeAlert(titleInput: "User is created", messageInput: "You can sign in with your password")
                            signUpButton.isHidden = true
                            signInButton.isHidden = false
                        } else {
                            makeAlert(titleInput: "User couldn't be created!", messageInput: "Restart your app and try again.")
                        }
                }
        } else {
            makeAlert(titleInput: "Password can't be shorter than 4 characters!", messageInput: "Try another password.")
        }
        
    }
    
    func makeAlert(titleInput: String, messageInput : String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkIfPasswordExists() -> Bool {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: "userPassword",
                kSecReturnData as String: kCFBooleanTrue!,
                kSecMatchLimit as String: kSecMatchLimitOne
            ]
            
            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)
            
            return status == errSecSuccess
        }
        
}

