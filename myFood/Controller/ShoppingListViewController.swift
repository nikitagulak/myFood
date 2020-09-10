//
//  ShoppingListViewController.swift
//  myFood
//
//  Created by Nick on 10.09.2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: Life-cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingListsTableView.dataSource = self
        shoppingListsTableView.delegate = self
        fetchResults()
    }
    
    
    //MARK: Istances
    var newShoppingListName = ""
    var shoppingLists: [String] = []
    
    @IBOutlet weak var shoppingListsTableView: UITableView!

    
    //MARK: TableView set up
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  shoppingListsTableView.dequeueReusableCell(withIdentifier: "shoppingList", for: indexPath)
        cell.textLabel?.text = shoppingLists[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: Creating a shopping list
    @IBAction func addShoppingList(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Enter a name of a shopping list", message: "e.g. Appartment, Cottage, Camp", preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField()
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
        }))
        
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
                //Save action
            if !alert.textFields![0].text!.isEmpty {
                self.saveNewData(name: alert.textFields![0].text!)
                self.shoppingLists = []
                self.fetchResults()
                self.shoppingListsTableView.reloadData()
                self.dismiss(animated: true, completion: nil)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: CoreData Saving
    func saveNewData(name: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "ShoppingLists", in: context)
                let newResult = NSManagedObject(entity: entity!, insertInto: context)
                newResult.setValue(name, forKey: "Name")
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
    }
    
    //MARK: CoreData Fetching
    func fetchResults() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingLists")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    shoppingLists.append(data.value(forKey: "name") as! String)
                }
                
            } catch {
                print("Failed fetching CoreData")
            }
    }
}
