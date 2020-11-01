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
        
        // MARK: Google Firebase setup
        fetchDataFromFireBase()
        
        myFoodTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "productCell")
        myFoodVC = self
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        myProducts = []
////        fetchDataFromFireBase()
//        myFoodTableView.reloadData()
//    }
    
    var myProducts: [ProductItem] = []
    
    @IBOutlet weak var myFoodTableView: UITableView!
    
    //MARK: TableView set up
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell") as! ProductTableViewCell
        cell.productName?.text = myProducts[indexPath.row].name
        cell.weight?.text = "\(myProducts[indexPath.row].weight) \(myProducts[indexPath.row].weightMesureType)"
//        cell.expireDate?.text = formatDate(date: myProducts[indexPath.row].expireDate!)
//        cell.expireDate?.text = "\(Calendar.current.dateComponents([.day], from: Date(), to: myProducts[indexPath.row].expireDate!).day!) days"
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
        let ref = Database.database().reference().child("myFood")
        
        ref.observe(.value) { (snapshot) in
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
    
//    func fetchDataFromFirebase2() -> [ProductItem] {
//        var fetchedProducts: [ProductItem] = []
//        let ref = Database.database().reference().child("myFood")
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//
//            for child in snapshot.children {
//                let snap = child as! DataSnapshot
////                let key = snap.key
//                let value = snap.value! as? NSDictionary
//                let productItem = ProductItem(name: value!["name"]! as! String, storingPlace: value!["storingPlace"]! as! String, weight: value!["weight"]! as! Int, weightMesureType: value!["weightMesureType"]! as! String)
////                self.myProducts.append(productItem)
//                fetchedProducts.append(productItem)
//                DispatchQueue.main.async {
//                    self.myFoodTableView.reloadData()
//                }
//            }
//
//          }) { (error) in
//            print(error.localizedDescription)
//        }
//        return fetchedProducts
//    }
    
}
