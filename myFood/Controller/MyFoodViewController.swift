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
        
        // Google Firebase setup
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
        cell.weight?.text = "\(products[indexPath.row].weight) \(products[indexPath.row].unit)"
        cell.expiryDate?.text = expiringToString(expiryDate: products[indexPath.row].expiryDate)
        cell.clockIcon.isHidden = products[indexPath.row].expiryDate == "" ? true : false
        
        tableView.deselectRow(at: indexPath, animated: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: Displaying Expiry Date
    func expiringToString(expiryDate: String) -> String {
        if expiryDate != "" {
            let stringDate = stringToDate(stringDate: expiryDate)
            let calendar = Calendar.current
            let years = calendar.dateComponents([.year], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: stringDate)).year!
            let months = calendar.dateComponents([.month], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: stringDate)).month!
            let days = calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: stringDate)).day!
            
            if years > 0 {
                return "Expires in \(years) years"
            } else if months > 0{
                return "Expires in \(months) months"
            } else if days > 0 {
                return "Expires in \(days) days"
            } else {
                return "Expired"
            }
        } else {
            return ""
        }
    }
    func stringToDate(stringDate: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm"
        guard let dateObject = formatter.date(from: "\(stringDate) 01:00") else { return Date() }
        return dateObject
    }
    
    // MARK: Google Firebase Fetching
    func fetchDataFromFireBase() {
        let ref = Database.database().reference().child("Users").child(String(UserDefaults.standard.string(forKey: "userID")!)).child("MyFood")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
//                let key = snap.key
                let value = snap.value! as? NSDictionary
                let productItem = ProductItem(name: value!["name"]! as! String, storingPlace: value!["storingPlace"]! as! String, weight: value!["weight"]! as! Int, unit: value!["unit"]! as! String, expiryDate: value!["expiryDate"] as? String ?? "")
                self.myProducts.append(productItem)
            }
            DispatchQueue.main.async {
                self.myFoodTableView.reloadData()
            }
        }
    }
}
