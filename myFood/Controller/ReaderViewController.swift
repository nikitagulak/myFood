//
//  ReaderViewController.swift
//  myFood
//
//  Created by Nick on 25.08.2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import UIKit
import CoreData
import BarcodeEasyScan
import FirebaseDatabase

//enum unit: String {
//    case grams = "grams";
//    case ml = "ml";
//    case peaces = "peaces"
//}

class ReaderViewController: UIViewController, ScanBarcodeDelegate {
     
    //MARK: Life-cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        attachDoneButtonToKeyboards()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.minimumDate = Date()
        myFoodVC?.myFoodTableView.reloadData()
        
        if isProductEditing == true {
            navigationBar.title = "Editing details"
            nameField.text = productForEditing?.name
            weightField.text = "\(productForEditing!.weight)"
            
            switch productForEditing?.unit {
            case "grams":
                weightTypeSwitcher.selectedSegmentIndex = 0
            case "ml":
                weightTypeSwitcher.selectedSegmentIndex = 1
            case "peaces":
                weightTypeSwitcher.selectedSegmentIndex = 2
            default:
                weightTypeSwitcher.selectedSegmentIndex = 0
            }
            
            switch productForEditing?.storingPlace {
            case "Fridge":
                storingPlaceSwitcher.selectedSegmentIndex = 0
            case "Freezer":
                storingPlaceSwitcher.selectedSegmentIndex = 1
            case "Pantry":
                storingPlaceSwitcher.selectedSegmentIndex = 2
            default:
                storingPlaceSwitcher.selectedSegmentIndex = 0
            }
            
            if productForEditing?.expiryDate != "" {
                datePicker.isHidden = false
                dateOfExpirySwitcher.isOn = true
                
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY-MM-dd"
                datePicker.date = formatter.date(from: productForEditing!.expiryDate) ?? Date()
            }
        }
    }
    
    
    //MARK: Istance variables
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var weightTypeSwitcher: UISegmentedControl!
    @IBOutlet weak var storingPlaceSwitcher: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateOfExpirySwitcher: UISwitch!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var isProductEditing: Bool = false
    var productForEditing: ProductItem?
    
    @IBAction func datePickerDateChanged(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        print(datePicker.date)
        print(formatter.string(from: datePicker.date))
    }
    
    @IBAction func dateOfExpirySwitcherChanged(_ sender: UISwitch) {
        if sender.isOn == true {
            datePicker.isHidden = false
        } else {
            datePicker.isHidden = true
        }
    }
    
    
    //MARK: Attaching Done button to keyboards
    func attachDoneButtonToKeyboards() {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(closeKeyboard))
        toolbar.setItems([doneBtn], animated: true)
        
        // assign toolbar
        nameField.inputAccessoryView = toolbar
        weightField.inputAccessoryView = toolbar
    }
    
    @objc func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    
    //MARK: Saving product
    @IBAction func saveProduct(_ sender: UIBarButtonItem) {
        // weight type switcher
        var weightMesureTypeSwitcherValue: String = ""
        switch weightTypeSwitcher.selectedSegmentIndex {
        case 0:
            weightMesureTypeSwitcherValue = "grams"
        case 1:
            weightMesureTypeSwitcherValue = "ml"
        case 2:
            weightMesureTypeSwitcherValue = "peaces"
        default:
            weightMesureTypeSwitcherValue = "grams"
        }
        
        // storing type switcher
        var storingPlaceSwitcherValue: String = ""
        switch storingPlaceSwitcher.selectedSegmentIndex {
        case 0:
            storingPlaceSwitcherValue = "Fridge"
        case 1:
            storingPlaceSwitcherValue = "Freezer"
        case 2:
            storingPlaceSwitcherValue = "Pantry"
        default:
            storingPlaceSwitcherValue = "Fridge"
        }
        
        // storing date
        var expiryDate: String = ""
        if datePicker.isHidden == false {
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd"
            expiryDate = formatter.string(from: datePicker.date)
        }
        
        if isProductEditing == true {
            updateDataInFireBase(id: productForEditing!.id, name: nameField.text!, weight: Int(weightField.text!)!, unit: weightMesureTypeSwitcherValue, storingPlace: storingPlaceSwitcherValue, expiryDate: expiryDate)
            
            productDetailsControllerVC?.product = ProductItem(id: productForEditing!.id, name: nameField.text!, storingPlace: storingPlaceSwitcherValue, weight: Int(weightField.text!)!, unit: weightMesureTypeSwitcherValue, expiryDate: expiryDate)
            productDetailsControllerVC?.updateDetails()
            productDetailsControllerVC?.tableView.reloadData()
            
        } else {
            saveDataToFireBase(name: nameField.text!, weight: Int(weightField.text!)!, unit: weightMesureTypeSwitcherValue, storingPlace: storingPlaceSwitcherValue, expiryDate: expiryDate)
        }
        
        myFoodVC?.myProducts = []
        myFoodVC?.fetchDataFromFireBase()
        self.dismiss(animated: true, completion: nil)
        productDetailsControllerVC?.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Barcode Scanner
    @IBAction func openBarcodeScanner(_ sender: UIButton) {
        let barcodeViewController =  BarcodeScannerViewController()
        barcodeViewController.delegate = self
        self.present(barcodeViewController, animated: true, completion: {
        })
    }
    
    func userDidScanWith(barcode: String) {
        print(barcode)
        getDataFromBarcode(barcode: barcode)
    }
    
    @objc func donePressed() {
        // formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        self.view.endEditing(true)
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Firebase Saving
    func saveDataToFireBase(name: String, weight: Int, unit: String, storingPlace: String, expiryDate: String) {
        let databasePath: String = "Users/" + "\(String(describing: UserDefaults.standard.string(forKey: "userID")!))/" + "MyFood"
        let ref = Database.database().reference().child(databasePath)
        ref.childByAutoId().setValue(["name":name,"storingPlace":storingPlace, "weight":weight, "unit":unit, "expiryDate":expiryDate])
    }
    
    func updateDataInFireBase(id: String, name: String, weight: Int, unit: String, storingPlace: String, expiryDate: String) {
        let databasePath: String = "Users/" + "\(String(describing: UserDefaults.standard.string(forKey: "userID")!))/" + "MyFood"
        let ref = Database.database().reference().child(databasePath).child(id)
        ref.updateChildValues(["name":name,"storingPlace":storingPlace, "weight":weight, "unit":unit, "expiryDate":expiryDate])
    }
    
    
    // MARK: Get data from OpenFoodFacts API
    func getDataFromBarcode(barcode: String) {
        let url = "https://world.openfoodfacts.org/api/v0/product/\(barcode)"
        if let urlObj = URL(string: url) {
          URLSession.shared.dataTask(with: urlObj) {(data, response, error) in
            do {
              let foodFactsObject = try JSONDecoder().decode(FoodFactsEntryPoint.self, from: data!)
                print("https://world.openfoodfacts.org/api/v0/product/\(barcode)")
                print("FOOD FACTS: \(foodFactsObject.product?.productNamePl ?? foodFactsObject.product?.productName ?? ""), \(foodFactsObject.product?.quantity ?? "")")
                DispatchQueue.main.async {
                    self.nameField.text = foodFactsObject.product?.productNamePl ?? foodFactsObject.product?.productName ?? ""
                    if foodFactsObject.product?.productQuantity != nil {
                        self.weightField.text = "\(foodFactsObject.product!.productQuantity!)"
                    }
                }
                
            } catch {
              print("Error of decoding JSON: \(error)")
            }
          }.resume()
        }
    }
    
        
}

//extension String {
//  func toDate(withFormat format: String = "yyyy-MM-dd") -> Date {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = format
//    guard let date = dateFormatter.date(from: self) else {
//      preconditionFailure("Take a look to your format")
//    }
//    return date
//  }
//}
