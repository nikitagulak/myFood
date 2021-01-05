//
//  SingleShoppingListController.swift
//  myFood
//
//  Created by Nick on 21/11/2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SingleShoppingListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Life-cycles
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.allowsSelection = true
        fetchProductsFromFirebase()
    }
    
    
    //MARK: Instance variables
    @IBOutlet weak var tableView: UITableView!
    var products: [String] = []
    
    
    //MARK: Actions
    @IBAction func addProduct(_ sender: UIButton) {
        let alert = UIAlertController(title: "Enter product name", message: "e.g. Avocado, Cheese, Cookies", preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField { textField in
            textField.autocapitalizationType = .sentences
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
        }))
        
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
                //Save action
            if !alert.textFields![0].text!.isEmpty {
                self.saveToShoppingList(productName: alert.textFields![0].text!)
                self.products = []
                self.fetchProductsFromFirebase()
                self.tableView.reloadData()
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func checkboxPressed(_ sender: UIButton) {
//        deleteFromDatabase(sender.index(ofAccessibilityElement: self))
    }
    
    
    //MARK: Saving to database
    func saveToShoppingList(productName: String) {
        let databasePath: String = "Users/" + "\(String(describing: UserDefaults.standard.string(forKey: "userID")!))/" + "ShoppingLists/" + self.navigationItem.title!
        let ref = Database.database().reference().child(databasePath)
        ref.child(productName).setValue("\(productName)")
//        ref.childByAutoId().setValue(["productName":productName, "isComplete":false])
    }
    
    
    //MARK: Fetch from database
    func fetchProductsFromFirebase() {
        let ref = Database.database().reference().child("Users").child(String(UserDefaults.standard.string(forKey: "userID")!)).child("ShoppingLists").child(self.navigationItem.title!)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                self.products.append(snap.key)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    //MARK: Deleting from database
    func deleteFromDatabase(childToDelete: String) {
        let databasePath: String = "Users/" + "\(String(describing: UserDefaults.standard.string(forKey: "userID")!))/" + "ShoppingLists/" + self.navigationItem.title! + "/\(childToDelete)"
        let ref = Database.database().reference().child(databasePath)
        ref.removeValue()
    }
    
    
    //MARK: TableView set up
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductToBuy", for: indexPath) as! ProductToBuyCell;
        cell.productName?.text = products[indexPath.row]
        
        // Action when checkbox is tapped
        cell.actionBlock = {
            
            /*
            let alert = UIAlertController(title: "Add product to MyFood list?", message: "", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
                
            }))
            
            alert.addAction(UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
//                self.dismiss(animated: true, completion: nil)
//                self.navigationController?.popViewController(animated: false)
//                self.navigationController?.popToRootViewController(animated: false)
                let nameVC = self.storyboard!.instantiateViewController(withIdentifier: "readerViewController") as! ReaderViewController
                self.navigationController?.pushViewController(nameVC, animated: true)
            }))
            
            self.present(alert, animated: true, completion: nil)
            */
            
            self.deleteFromDatabase(childToDelete: cell.productName!.text!)
            DispatchQueue.main.async {
                self.products = []
            }
            self.fetchProductsFromFirebase()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        return cell
    }
    
}
