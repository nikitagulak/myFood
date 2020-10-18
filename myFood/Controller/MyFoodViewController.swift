//
//  MyFoodViewController.swift
//  myFood
//
//  Created by Nick on 23.08.2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import UIKit
import CoreData
import FirebaseDatabase

var myFoodVC: MyFoodViewController?

class MyFoodViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Life-cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        myFoodTableView.dataSource = self
        myFoodTableView.delegate = self
        myFoodTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "productCell")
        myFoodVC = self
        
        // MARK: Google Firebase setup
        fetchDataFromFireBase()
//        let ref = Database.database().reference()
////        ref.childByAutoId().setValue(["name":"Cookies","storingPlace":"Pantry"])
//        ref.child("myFood").observeSingleEvent(of: .value) { (snapshot) in
//            guard let data = snapshot.value as? [String:Any] else {
//                return
//            }
//            print("\n\n")
//            print(data)
//            print("\n\n")
////            print(snapshot.value!)
//            let value = snapshot.value as? NSDictionary
//            let name = value?["product1"] as? [String:Any] ?? ["":""]
//            print(name)
//
//            for child in snapshot.children {
////                let value = snapshot.children.value(forKey: "name")
//                let enumerator = snapshot.children
//                while let rest = enumerator.nextObject() as? DataSnapshot {
//                       print(rest.value)
//                    }
//            }
//
////            for child in snapshot.children {
////                let value = snapshot.value as? NSDictionary
////                let name = value?["name"] as? String ?? ""
////                let storingPlace = value?["storingPlace"] as? String ?? "Pantry"
////                let weight = value?["weight"] as? Int ?? 0
////                let weightMesureType = value?["weightMesureType"] as? String ?? "grams"
////                let productItem = ProductItem(name: name, storingPlace: storingPlace, weight: weight, weightMesureType: weightMesureType)
////                print(productItem)
////            }
//        }
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
    
    func fetchDataFromFireBase() {
        let ref = Database.database().reference().child("myFood")
        
        ref.observe(.value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                let value = snap.value! as? NSDictionary
                print(value!["name"]!, value!["weight"]!)
            }
        }
    }
    
}
