//
//  AddMealController.swift
//  myFood
//
//  Created by Nick on 28/11/2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddMealController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        styleChips()
        styleTimePicker()
        attachDoneButtonToKeyboards()
        dietVC?.tableView.reloadData()
    }
    
    
    //MARK: Instance variables
    @IBOutlet weak var breakfastChip: UIButton!
    @IBOutlet weak var brunchChip: UIButton!
    @IBOutlet weak var lunchChip: UIButton!
    @IBOutlet weak var dinnerChip: UIButton!
    @IBOutlet weak var supperChip: UIButton!
    @IBOutlet weak var snackChip: UIButton!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var dishField: UITextField!
    
    var mealTypeChipValue: String?
    var time: String?
    var dayOfWeek: String?
    
    
    //MARK: Actions
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        if dishField.text != "" && mealTypeChipValue != nil {
            saveToFirebase(mealType: mealTypeChipValue!, dish: dishField.text!, time: time)
        }
        dietVC?.mealPlan = [:]
        dietVC?.fetchMealPlanFromFirebase()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func timeSwitcherChanged(_ sender: UISwitch) {
        if sender.isOn == true {
            timePicker.isHidden = false
        } else {
            timePicker.isHidden = true
        }
    }
    
    @IBAction func timePickerChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        time = formatter.string(from: timePicker.date)
    }
    
    @IBAction func mealTypeChipPressed(_ sender: UIButton) {
        
        switch sender.titleLabel!.text! {
        case "Breakfast":
            selectMealTypeChip(chipName: breakfastChip.titleLabel!.text!)
        case "Brunch":
            selectMealTypeChip(chipName: brunchChip.titleLabel!.text!)
        case "Lunch":
            selectMealTypeChip(chipName: lunchChip.titleLabel!.text!)
        case "Dinner":
            selectMealTypeChip(chipName: dinnerChip.titleLabel!.text!)
        case "Supper":
            selectMealTypeChip(chipName: supperChip.titleLabel!.text!)
        case "Snack":
            selectMealTypeChip(chipName: snackChip.titleLabel!.text!)
        default:
            return
        }
    }
    
    func styleChips() {
        breakfastChip.layer.masksToBounds = true
        brunchChip.layer.masksToBounds = true
        lunchChip.layer.masksToBounds = true
        dinnerChip.layer.masksToBounds = true
        supperChip.layer.masksToBounds = true
        snackChip.layer.masksToBounds = true
        
        breakfastChip.layer.cornerRadius = 28
        brunchChip.layer.cornerRadius = 28
        lunchChip.layer.cornerRadius = 28
        dinnerChip.layer.cornerRadius = 28
        supperChip.layer.cornerRadius = 28
        snackChip.layer.cornerRadius = 28
    }
    
    func selectMealTypeChip(chipName: String) {
        
        let chips = [breakfastChip, brunchChip, lunchChip, dinnerChip, supperChip, snackChip]
        
        for selectedChip in chips {
            if selectedChip?.titleLabel!.text! == chipName {
                mealTypeChipValue = chipName
                selectedChip?.backgroundColor = UIColor(red: 0.84, green: 0.96, blue: 0.87, alpha: 1.00)
                selectedChip?.setTitleColor(UIColor.systemGreen, for: .normal)
                selectedChip?.titleLabel?.font = UIFont(name: "System Font Semibold", size: 15)
            } else {
                selectedChip?.backgroundColor = UIColor.systemGray6
                selectedChip?.setTitleColor(UIColor.lightGray, for: .normal)
                selectedChip?.titleLabel?.font = UIFont(name: "System Font Regular", size: 15)
            }
        }
    }
    
    func styleTimePicker() {
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .compact
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let initialTime = formatter.date(from: "06:00")
        timePicker.date = initialTime!
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
        dishField.inputAccessoryView = toolbar
    }
    
    @objc func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    //MARK: Saving to database
    func saveToFirebase(mealType: String, dish: String, time: String?) {
        let databasePath: String = "Users/" + "\(String(describing: UserDefaults.standard.string(forKey: "userID")!))/" + "MealPlan/" + dayOfWeek!
        let ref = Database.database().reference().child(databasePath)
        ref.childByAutoId().setValue(["mealType":mealType, "dish":dish, "time":time ?? ""])
    }


}

