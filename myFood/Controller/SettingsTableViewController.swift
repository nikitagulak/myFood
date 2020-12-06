//
//  SettingsTableViewController.swift
//  myFood
//
//  Created by Nick on 15.11.2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        let rightBarButtonItem = UIBarButtonItem()
        rightBarButtonItem.title = "Logout"
        rightBarButtonItem.tintColor = UIColor.red
        rightBarButtonItem.target = self
        rightBarButtonItem.action = #selector(logout)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        nameLabel.text = UserDefaults.standard.string(forKey: "userName") ?? "User name is undefined"
        emailLabel.text = FirebaseAuth.Auth.auth().currentUser?.email
        
        nameAccessoryLabel.text = UserDefaults.standard.string(forKey: "userName") ?? "User name is undefined"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameLabel.text = UserDefaults.standard.string(forKey: "userName") ?? "User name is undefined"
        nameAccessoryLabel.text = UserDefaults.standard.string(forKey: "userName") ?? "User name is undefined"
    }
    
    //MARK: Instance variables
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameAccessoryLabel: UILabel!
    
    
    @objc public func logout(sender: UIBarButtonItem) {
        UserDefaults.standard.removeObject(forKey: "userID")
        UserDefaults.standard.removeObject(forKey: "userName")
        do {
            try FirebaseAuth.Auth.auth().signOut()
        } catch {
            print("Failed logging out")
        }
        
        let nextViewController = storyboard?.instantiateViewController(identifier: "welcome") as! UINavigationController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ChangeNameController
        destinationVC.currentName = nameLabel.text
    }
    
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 3
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.section)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1.00)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1.00)
    }
}
