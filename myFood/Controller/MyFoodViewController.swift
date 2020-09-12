//
//  MyFoodViewController.swift
//  myFood
//
//  Created by Nick on 23.08.2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import UIKit
import CoreData

class MyFoodViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Life-cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        myFoodTableView.dataSource = self
        myFoodTableView.delegate = self
//        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myProducts = []
        fetchResults()
    }
    
    var myProducts: [String] = []
    
    @IBOutlet weak var myFoodTableView: UITableView!
    
    //MARK: TableView set up
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
        cell.textLabel?.text = myProducts[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: CoreData Fetching
    func fetchResults() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyProducts")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    myProducts.append(data.value(forKey: "name") as! String)
                }
                
            } catch {
                print("Failed fetching CoreData")
            }
    }
    
}
