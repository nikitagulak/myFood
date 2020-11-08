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
import FirebaseAuth

var myFoodVC: MyFoodViewController?

class MyFoodViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Life-cycles
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("USER ID: \(String(describing: UserDefaults.standard.string(forKey: "userID")!))")
//        print("USER ID: \(String(describing: Auth.auth().currentUser!.uid))")
        
        // MARK: Google Firebase setup
        fetchDataFromFireBase()
        
        myFoodTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "productCell")
        myFoodVC = self
    }
    
    //MARK: Instance variables
    var myProducts: [ProductItem] = []
    var dataFilter: Int = 0
    
    @IBOutlet weak var myFoodTableView: UITableView!
    @IBOutlet weak var storingPlaceSwitcher: UISegmentedControl!
    
    //MARK: Filtering products by place of storing
    @IBAction func storingPlaceSwitcherChanged(_ sender: Any) {
        switch storingPlaceSwitcher.selectedSegmentIndex {
        case 0:
            dataFilter = 0
            myFoodTableView.reloadData()
        case 1:
            dataFilter = 1
            myFoodTableView.reloadData()
        case 2:
            dataFilter = 2
            myFoodTableView.reloadData()
        case 3:
            dataFilter = 3
            myFoodTableView.reloadData()
        default:
            return
        }
    }
    
    func storingPlaceFilterHandler() -> [ProductItem] {
        
        var filteredProducts: [ProductItem] = []
        
        switch dataFilter {
        case 0:
            return myProducts
        case 1:
            for product in myProducts {
                if product.storingPlace == "Fridge" {
                    filteredProducts.append(product)
                }
            }
            return filteredProducts
        case 2:
            for product in myProducts {
                if product.storingPlace == "Freezer" {
                    filteredProducts.append(product)
                }
            }
            return filteredProducts
        case 3:
            for product in myProducts {
                if product.storingPlace == "Pantry" {
                    filteredProducts.append(product)
                }
            }
            return filteredProducts
        default:
            return myProducts
        }
    }
    
    
    //MARK: TableView set up
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let products: [ProductItem] = storingPlaceFilterHandler()
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let products: [ProductItem] = storingPlaceFilterHandler()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell") as! ProductTableViewCell
        cell.productName?.text = products[indexPath.row].name
        cell.weight?.text = "\(products[indexPath.row].weight) \(products[indexPath.row].weightMesureType)"
//        cell.expireDate?.text = formatDate(date: products[indexPath.row].expireDate!)
//        cell.expireDate?.text = "\(Calendar.current.dateComponents([.day], from: Date(), to: products[indexPath.row].expireDate!).day!) days"
        cell.expireDate?.text = "0 days"
        
        tableView.deselectRow(at: indexPath, animated: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    
    // MARK: Google Firebase Fetching
    func fetchDataFromFireBase() {
        let ref = Database.database().reference().child("Users").child(String(UserDefaults.standard.string(forKey: "userID")!)).child("MyFood")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
//                let key = snap.key
                let value = snap.value! as? NSDictionary
                let productItem = ProductItem(name: value!["name"]! as! String, storingPlace: value!["storingPlace"]! as! String, weight: value!["weight"]! as! Int, weightMesureType: value!["weightMesureType"]! as! String)
                self.myProducts.append(productItem)
                DispatchQueue.main.async {
                    self.myFoodTableView.reloadData()
                }
            }
        }
    }
}
