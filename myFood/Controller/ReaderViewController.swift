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
        createDatePicker()
        attachDoneButtonToKeyboards()
        myFoodVC?.myFoodTableView.reloadData()
    }
    
    //MARK: Istances
    @IBOutlet weak var dateOfExpiryField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var weightTypeSwitcher: UISegmentedControl!
    @IBOutlet weak var storingPlaceSwitcher: UISegmentedControl!
    
    let datepicker = UIDatePicker()
    
    
    //MARK: Attaching Done button to keyboards
    func attachDoneButtonToKeyboards() {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(closeKeyboard))
        toolbar.setItems([doneBtn], animated: true)
        
        // assign toolbar
        dateOfExpiryField.inputAccessoryView = toolbar
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
        
//        saveNewData(name: nameField.text!, weight: Int(weightField.text!)!, weightMesureType: weightMesureTypeSwitcherValue, storingPlace: storingPlaceSwitcherValue, expiryDate: datepicker.date )
        saveDataToFireBase(name: nameField.text!, weight: Int(weightField.text!)!, weightMesureType: weightMesureTypeSwitcherValue, storingPlace: storingPlaceSwitcherValue)
        
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
    
    //MARK: Date-Picker
    func createDatePicker() {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        // assign toolbar
        dateOfExpiryField.inputAccessoryView = toolbar
        
        // assign datepicker to the text field
        dateOfExpiryField.inputView = datepicker
        
        // datepicker mode
        datepicker.datePickerMode = .date
    }
    
    @objc func donePressed() {
        // formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        dateOfExpiryField.text = formatter.string(from: datepicker.date)
        print(formatter.string(from: datepicker.date))
        print(datepicker.date)
        self.view.endEditing(true)
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: CoreData Saving
    func saveNewData(name: String, weight: Int, weightMesureType: String, storingPlace: String, expiryDate: Date) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "MyProducts", in: context)
                let newResult = NSManagedObject(entity: entity!, insertInto: context)
                newResult.setValue(name, forKey: "Name")
                newResult.setValue(weight, forKey: "weight")
                newResult.setValue(weightMesureType, forKey: "weightMesureType")
                newResult.setValue(storingPlace, forKey: "storingPlace")
                newResult.setValue(expiryDate, forKey: "expiryDate")
                do {
                    try context.save()
                    myFoodVC?.fetchDataFromFireBase()
                    myFoodVC?.myFoodTableView.reloadData()
                } catch {
                    print("Failed saving")
                }
    }
    
    func saveDataToFireBase(name: String, weight: Int, weightMesureType: String, storingPlace: String) {
        let ref = Database.database().reference().child("myFood")
        
        ref.childByAutoId().setValue(["name":name,"storingPlace":storingPlace, "weight":weight, "weightMesureType":weightMesureType])
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
