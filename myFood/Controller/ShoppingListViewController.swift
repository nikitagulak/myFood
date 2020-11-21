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

class ShoppingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: Life-cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingListsTableView.tableFooterView = UIView()
        fetchShoppingListsFromFireBase()
        print("ARRAY: \(shoppingLists)")
    }
    
    
    //MARK: Istances
    var newShoppingListName = ""
    var shoppingLists: [String] = []
    
    @IBOutlet weak var shoppingListsTableView: UITableView!

    
    //MARK: TableView set up
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  shoppingListsTableView.dequeueReusableCell(withIdentifier: "ShoppingListCell", for: indexPath)
//        cell.textLabel?.text = shoppingLists[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
                print("ARRAY: \(self.shoppingLists)")
                self.shoppingListsTableView.reloadData()
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
                print("SNAP is: \(snap.key)")
                let shoppingList = snap.key
                self.shoppingLists.append(shoppingList)
                DispatchQueue.main.async {
                    self.shoppingListsTableView.reloadData()
                    print("ARRAY: \(self.shoppingLists)")
                }
            }
        }
        
    }
    
    //MARK: CoreData Saving
//    func saveNewData(name: String) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                let context = appDelegate.persistentContainer.viewContext
//                let entity = NSEntityDescription.entity(forEntityName: "ShoppingLists", in: context)
//                let newResult = NSManagedObject(entity: entity!, insertInto: context)
//                newResult.setValue(name, forKey: "Name")
//                do {
//                    try context.save()
//                } catch {
//                    print("Failed saving")
//                }
//    }
    
    //MARK: CoreData Fetching
//    func fetchResults() {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let context = appDelegate.persistentContainer.viewContext
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingLists")
//            request.returnsObjectsAsFaults = false
//            do {
//                let result = try context.fetch(request)
//                for data in result as! [NSManagedObject] {
//                    shoppingLists.append(data.value(forKey: "name") as! String)
//                }
//
//            } catch {
//                print("Failed fetching CoreData")
//            }
//    }
}
