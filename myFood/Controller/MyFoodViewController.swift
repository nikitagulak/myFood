//
//  MyFoodViewController.swift
//  myFood
//
//  Created by Nick on 23.08.2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import UIKit
import CoreData

var myFoodVC: MyFoodViewController?

class MyFoodViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Life-cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        myFoodTableView.dataSource = self
        myFoodTableView.delegate = self
        myFoodTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "productCell")
//        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        myFoodVC = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myProducts = []
        fetchResults()
        myFoodTableView.reloadData()
    }
    
    var myProducts: [Product] = []
    
    @IBOutlet weak var myFoodTableView: UITableView!
    
    //MARK: TableView set up
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell") as! ProductTableViewCell
        cell.productName?.text = myProducts[indexPath.row].name
        cell.weight?.text = "\(myProducts[indexPath.row].weigth) \(myProducts[indexPath.row].weightMesureType)"
//        cell.expireDate?.text = formatDate(date: myProducts[indexPath.row].expireDate!)
        cell.expireDate?.text = "\(Calendar.current.dateComponents([.day], from: Date(), to: myProducts[indexPath.row].expireDate!).day!) days"
        
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
                    myProducts.append(Product(name: data.value(forKey: "name") as! String, weigth: data.value(forKey: "weight") as! Int, weightMesureType: data.value(forKey: "weightMesureType") as! String, storingPlace: data.value(forKey: "storingPlace") as! String, expireDate: data.value(forKey: "expiryDate") as? Date, barcode: data.value(forKey: "barcode") as? String))
                }
                
            } catch {
                print("Failed fetching CoreData")
            }
    }
    
    func formatDate(date: Date) -> String {
        let datepicker = UIDatePicker()
        let formatter = DateFormatter()
        var dateFromCoreData = "\(date)"
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        dateFromCoreData = formatter.string(from: datepicker.date)
        return dateFromCoreData
    }
    
}
