//
//  SettingsViewController.swift
//  myFood
//
//  Created by Nick on 24.10.2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutButton(_ sender: UIBarButtonItem) {
        UserDefaults.standard.removeObject(forKey: "userID")
        let nextViewController = storyboard?.instantiateViewController(identifier: "welcome") as! UINavigationController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated: false, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
