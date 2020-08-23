//
//  ViewController.swift
//  myFood
//
//  Created by Nick on 05.08.2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        let signInVC = storyboard!.instantiateViewController(withIdentifier: "signInVC") 
        navigationController?.pushViewController(signInVC, animated: true)
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        let registerVC = storyboard!.instantiateViewController(withIdentifier: "registerVC")
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
}

