//
//  ReaderViewController.swift
//  myFood
//
//  Created by Nick on 25.08.2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import UIKit
import BarcodeEasyScan

class ReaderViewController: UIViewController, ScanBarcodeDelegate {
     
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
    }
    
    @IBOutlet weak var dateOfExpiryField: UITextField!
    
    let datepicker = UIDatePicker()
    
    @IBAction func openBarcodeScanner(_ sender: UIButton) {
        let barcodeViewController =  BarcodeScannerViewController()
        barcodeViewController.delegate = self
        self.present(barcodeViewController, animated: true, completion: {
        })
    }
    
    func userDidScanWith(barcode: String) {
        print(barcode)
    }
    
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
        
}


