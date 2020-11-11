//
//  ViewController.swift
//  myFood
//
//  Created by Nick on 05.08.2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

//import FBSDKLoginKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Checking if user is authorized
        if UserDefaults.standard.string(forKey: "userID") != nil {
            openHomescreen()
        }
        
        // Hide NavBar on welcome screen
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if navigationController?.navigationBar.isHidden == false {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        } else {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        
        // Setting font size of Tab Bar items
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font:UIFont(name: "System Font Bold", size: 11)!]
        appearance.setTitleTextAttributes(attributes, for: .normal)
        
//        let loginButton = FBLoginButton()
//        loginButton.center = view.center
//        view.addSubview(loginButton)
    }
    
    @IBOutlet weak var signInEmailField: UITextField!
    @IBOutlet weak var signInPasswordField: UITextField!
    @IBOutlet weak var registerNameField: UITextField!
    @IBOutlet weak var registerEmailField: UITextField!
    @IBOutlet weak var registerPasswordField: UITextField!
    
    @IBAction func signInButton(_ sender: UIButton) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let signInVC = storyboard!.instantiateViewController(withIdentifier: "signInVC") 
        navigationController?.pushViewController(signInVC, animated: true)
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let registerVC = storyboard!.instantiateViewController(withIdentifier: "registerVC")
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func submitSignInButton(_ sender: UIButton) {
        let email = signInEmailField.text
        let pass = signInPasswordField.text
        
        if areFieldsEmpty(fields: [email!, pass!]) {
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email!, password: pass!) { (result, error) in
            // Login failed
            guard error == nil else {
                self.displayAlert(title: "Login failed", message: "Invalid email or password")
                return
            }
            // Login succeed
            print(result!.user.uid as String)
            UserDefaults.standard.set(result!.user.uid as String, forKey: "userID")
            self.openHomescreen()
        }
    }
    
    @IBAction func submitRegistrationButton(_ sender: UIButton) {
        let name = registerNameField.text
        let email = registerEmailField.text
        let pass = registerPasswordField.text
        
        if areFieldsEmpty(fields: [name!, email!, pass!]) {
            return
        }
        
        // Creation a user
        FirebaseAuth.Auth.auth().createUser(withEmail: email!, password: pass!) { (result, error) in
            // Registration failed
            guard error == nil else {
                self.displayAlert(title: "Registration failed", message: "Either email is incorrect or password is less than 6 symbols")
                return
            }
            // Registration succeed
            UserDefaults.standard.set(result!.user.uid as String, forKey: "userID")
            
            DispatchQueue.main.async {
                UserDefaults.standard.set(result!.user.uid as String, forKey: "userID")
                let databasePath: String = "Users/" + "\(String(result!.user.uid))"
                let ref = Database.database().reference().child(databasePath)
                ref.child("Account").setValue(["Name":name])
            }
            
            self.openHomescreen()
        }
        
        // Saving user's name
//        let databasePath: String = "Users/" + "\(String(describing: UserDefaults.standard.string(forKey: "userID")!))"
//        let ref = Database.database().reference().child(databasePath)
//        ref.child("Account").setValue(["Name":name])
        
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func areFieldsEmpty(fields: [String]) -> Bool {
        for field in fields {
            if field == "" {
                displayAlert(title: "Missing data", message: "All fields should be filled up")
                return true
            }
        }
        return false
    }
    
    func openHomescreen() {
        let nextViewController = storyboard?.instantiateViewController(identifier: "homescreen") as! UITabBarController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated: false, completion: nil)
    }
    
}

