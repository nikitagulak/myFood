//
//  GenerateMealController.swift
//  myFood
//
//  Created by Nick on 12/12/2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import UIKit
import AnyCodable

class GenerateMealController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        dietPicker.delegate = self
        dietPicker.dataSource = self
        styleDietField()
        attachDoneButtonToKeyboards()
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    // MARK: Instance variables
    @IBOutlet weak var targetCaloriesField: UITextField!
    @IBOutlet weak var dietField: NonEditableTextField!
    @IBOutlet weak var excludeField: UITextField!
    
    let diets = ["", "Gluten Free", "Ketogenic", "Vegetarian", "Lacto-Vegetarian", "Ovo-Vegetarian", "Vegan", "Pescetarian", "Paleo", "Primal", "Whole30"]
    var dietPicker = UIPickerView()
    var selectedDiet: String?
    var mealPlanToPass: MealPlan?
    
    
    // MARK: Actions
    @IBAction func generateBtn(_ sender: UIButton) {
//        getDataFromServer(url: URL(string: "http://169.254.153.221:3000")!)
//        getDataFromServer(url: URL(string: "http://localhost:3000")!)
        
        let nextViewController = storyboard?.instantiateViewController(identifier: "MealPlanResponseVC") as! MealPlanResponseController
//        generateMealPlanRequest(targetCalories: targetCaloriesField.text ?? "", diet: dietField.text ?? "", exclude: excludeField.text ?? "")
//        self.present(nextViewController, animated: true, completion: nil)
//        self.navigationController?.showDetailViewController(nextViewController, sender: self)
        nextViewController.parameters["targetCalories"] = targetCaloriesField.text ?? ""
        nextViewController.parameters["diet"] = dietField.text ?? ""
        nextViewController.parameters["exclude"] = excludeField.text ?? ""
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Diet picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return diets.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return diets[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dietField.text = diets[row]
    }
    
    
    // MARK: Connect to server
    func getDataFromServer(url: URL) {
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    
    // MARK: Get data from Spoonacular API
    func generateMealPlanRequest(targetCalories: String, diet: String, exclude: String) {
        let apiKey = "c9048153061a4a4fa5d14861e1740e74"
        let url = "https://api.spoonacular.com/mealplanner/generate?apiKey=\(apiKey)&timeFrame=week&targetCalories=\(targetCalories)&diet=\(diet)&exclude=\(exclude)"
        print(url)
        if let urlObj = URL(string: url) {
          URLSession.shared.dataTask(with: urlObj) {(data, response, error) in
            do {
                let mealPlan = try JSONDecoder().decode(MealPlan.self, from: data!)
                
                print(url)
                print(mealPlan.week?.monday?.meals?[0])
            } catch {
              print("Error of decoding JSON: \(error)")
            }
          }.resume()
        }
    }
    
    
    //MARK: Attaching Done button to keyboards
    func attachDoneButtonToKeyboards() {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // creating flexible space
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        // creating done button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(closeKeyboard))
        toolbar.setItems([doneBtn], animated: true)
        
        // adding space and button to toolbar
        toolbar.setItems([flexibleSpace, doneBtn], animated: false)
        
        // assign toolbar
        dietField.inputAccessoryView = toolbar
        targetCaloriesField.inputAccessoryView = toolbar
        excludeField.inputAccessoryView = toolbar
    }
    
    @objc func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    
    // MARK: Attaching arrow icon to textField
    func styleDietField() {
        dietField.inputView = dietPicker
        dietField.text = diets[0]
        dietField.tintColor = .clear
        
//        dietField.rightViewMode = .always
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
//        let image = UIImage(systemName: "chevron.down", withConfiguration: boldConfig)
//        imageView.image = image
//        dietField.rightView = imageView
    }
    
    
}

class NonEditableTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
