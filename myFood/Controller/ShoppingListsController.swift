//
//  ShoppingListViewController.swift
//  myFood
//
//  Created by Nick on 10.09.2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import UIKit
//import CoreData
import FirebaseDatabase

class ShoppingListsController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: Life-cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        fetchShoppingListsFromFireBase()
        spinner.startAnimating()
    }
    
    
    //MARK: Istances
    var shoppingLists: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    //MARK: TableView set up
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell", for: indexPath) as! ShoppingListCell
//        cell.textLabel?.text = shoppingLists[indexPath.row]
        cell.listNameLabel?.text = shoppingLists[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.deleteFromDatabase(listToDelete: self.shoppingLists[indexPath.row])
            DispatchQueue.main.async {
                self.shoppingLists = []
            }
            self.fetchShoppingListsFromFireBase()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            completionHandler(true)
        }
        action.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SingleShoppingListController
        let cell = sender as! ShoppingListCell
        destinationVC.navigationItem.title = cell.listNameLabel?.text
    }
    
    //MARK: Creating a shopping list
    @IBAction func addShoppingList(_ sender: UIButton) {
        let alert = UIAlertController(title: "Enter a name of a shopping list", message: "e.g. Appartment, Cottage, Camp", preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField { textField in
            textField.autocapitalizationType = .sentences
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
        }))
        
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
                //Save action
            if !alert.textFields![0].text!.isEmpty {
                self.saveShoppingListToFireBase(listName: alert.textFields![0].text!)
                self.shoppingLists = []
                self.fetchShoppingListsFromFireBase()
                self.tableView.reloadData()
//                self.dismiss(animated: true, completion: nil)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: Firebase Saving
    func saveShoppingListToFireBase(listName: String) {
        let databasePath: String = "Users/" + "\(String(describing: UserDefaults.standard.string(forKey: "userID")!))/" + "ShoppingLists/"
        let ref = Database.database().reference().child(databasePath)
        ref.child(listName).setValue("\(listName)")
//        ref.childByAutoId().setValue(["listNname":listName])
    }
    
    
    // MARK: Google Firebase Fetching
    func fetchShoppingListsFromFireBase() {
        let ref = Database.database().reference().child("Users").child(String(UserDefaults.standard.string(forKey: "userID")!)).child("ShoppingLists")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                self.shoppingLists.append(snap.key)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
            }
        }
        
    }
    
    
    //MARK: Deleting from database
    func deleteFromDatabase(listToDelete: String) {
        let databasePath: String = "Users/" + "\(String(describing: UserDefaults.standard.string(forKey: "userID")!))/" + "ShoppingLists/" + listToDelete
        let ref = Database.database().reference().child(databasePath)
        ref.removeValue()
    }

}
