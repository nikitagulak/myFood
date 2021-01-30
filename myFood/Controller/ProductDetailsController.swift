//
//  ProductDetailsController.swift
//  myFood
//
//  Created by Nick on 24/11/2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import UIKit

var productDetailsControllerVC: ProductDetailsController?

class ProductDetailsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productDetailsControllerVC = self
        updateDetails()
    }
    
    func updateDetails() {
        productName.text = product?.name
        
        productValues.append(["Weight", String(product!.weight) + " " + product!.unit])
        productValues.append(["Place of storing", product?.storingPlace ?? ""])
        productValues.append(["Date of expiry", product!.expiryDate])
    
        tableView.reloadData()
    }
    
    //MARK: Instance variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var productName: UILabel!
    
    var product: ProductItem?
    var productValues = [[String]]()
    
    
    //MARK: Actions
    @IBAction func closeView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "editProductDetails", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProductDetails" {
            let displayVC = segue.destination as! ReaderViewController
            displayVC.isProductEditing = true
            displayVC.productForEditing = product
            
        }
    }
    
    
    //MARK: TableView set up
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsCell", for: indexPath);
//        cell.textLabel?.text = productValues[indexPath.row].[0]
        cell.textLabel?.text = productValues[indexPath.row][0]
        cell.detailTextLabel?.text = productValues[indexPath.row][1]
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
