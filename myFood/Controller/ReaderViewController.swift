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

class ReaderViewController: UIViewController, ScanBarcodeDelegate {
     
    //MARK: Life-cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        attachDoneButtonToKeyboards()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.minimumDate = Date()
        myFoodVC?.myFoodTableView.reloadData()
    }
    
    //MARK: Istance variables
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var weightTypeSwitcher: UISegmentedControl!
    @IBOutlet weak var storingPlaceSwitcher: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    
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
        
        saveDataToFireBase(name: nameField.text!, weight: Int(weightField.text!)!, weightMesureType: weightMesureTypeSwitcherValue, storingPlace: storingPlaceSwitcherValue, expiryDate: expiryDate )
        myFoodVC?.myProducts = []
        myFoodVC?.fetchDataFromFireBase()
        self.dismiss(animated: true, completion: nil)
        
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
    func saveDataToFireBase(name: String, weight: Int, weightMesureType: String, storingPlace: String, expiryDate: String) {
        let databasePath: String = "Users/" + "\(String(describing: UserDefaults.standard.string(forKey: "userID")!))/" + "MyFood"
        let ref = Database.database().reference().child(databasePath)
        ref.childByAutoId().setValue(["name":name,"storingPlace":storingPlace, "weight":weight, "weightMesureType":weightMesureType, "expiryDate":expiryDate])
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
