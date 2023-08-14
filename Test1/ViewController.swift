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
    
    //*** anlaşıldı ***
    @IBAction func signInButtonClicked(_ sender: Any) {
        
        if let enteredPassword = passwordTextField.text {
                let query: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrAccount as String: "userPassword",
                    kSecReturnData as String: kCFBooleanTrue!,
                    kSecMatchLimit as String: kSecMatchLimitOne
                ]
                
            
            var item: CFTypeRef?
            let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &item)

            switch status {
            case errSecSuccess:
                if let passwordData = item as? Data, let password = String(data: passwordData, encoding: .utf8) {
                    if enteredPassword == password {
                        performSegue(withIdentifier: "toList", sender: nil)
                    } else {
                        makeAlert(titleInput: "Error", messageInput: "Password doesn't match.")
                    }
                } else {
                    makeAlert(titleInput: "Error", messageInput: "Failed to retrieve password data.")
                }
            case errSecItemNotFound:
                makeAlert(titleInput: "Error", messageInput: "Item not found in Keychain.")
            case errSecAuthFailed:
                makeAlert(titleInput: "Error", messageInput: "Authentication failed.")
            case errSecUserCanceled:
                makeAlert(titleInput: "Error", messageInput: "User canceled the operation.")
            default:
                makeAlert(titleInput: "Error", messageInput: "An unknown error occurred.")
            }

        }
        
    }
    
    //*** anlaşıldı ***
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
            
                switch status {
                case errSecSuccess:
                    makeAlert(titleInput: "Success", messageInput: "Operation completed successfully.")
                    signUpButton.isHidden = true
                    signInButton.isHidden = false
                case errSecDuplicateItem:
                    makeAlert(titleInput: "Error", messageInput: "This item already exists in the Keychain.")
                case errSecItemNotFound:
                    makeAlert(titleInput: "Error", messageInput: "The specified item could not be found in the Keychain.")
                case errSecAuthFailed:
                    makeAlert(titleInput: "Error", messageInput: "Authentication failed. Incorrect password or missing authorization.")
                case errSecDecode:
                    makeAlert(titleInput: "Error", messageInput: "Data decoding error.")
                case errSecParam:
                    makeAlert(titleInput: "Error", messageInput: "Invalid parameter error.")
                case errSecNotAvailable:
                    makeAlert(titleInput: "Error", messageInput: "Keychain services are not available.")
                case errSecUserCanceled:
                    makeAlert(titleInput: "Error", messageInput: "The user canceled the operation.")
                case errSecInteractionNotAllowed:
                    makeAlert(titleInput: "Error", messageInput: "User interaction is not allowed.")
                case errSecUnimplemented:
                    makeAlert(titleInput: "Error", messageInput: "Operation is not yet implemented or supported.")
                default:
                    makeAlert(titleInput: "Error", messageInput: "Unknown error occurred.")
                }
            }
        } else {
            makeAlert(titleInput: "Password can't be shorter than 4 characters!", messageInput: "Try another password.")
        }
        
    }
    //*** anlaşıldı ***
    func makeAlert(titleInput: String, messageInput : String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //*** anlaşıldı ***
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

