//
//  DietViewController.swift
//  myFood
//
//  Created by Nick on 11.11.2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import UIKit
import FirebaseDatabase

var dietVC: DietViewController?

class DietViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Life-cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        dietVC = self
        spinner.startAnimating()
        fetchMealPlanFromFirebase()
        weekDayInitialSetup()
    }
    
    
    //MARK: Instance variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var weekDaySwitcher: UISegmentedControl!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var mealPlan: [String:[Meal]] = [:]
    var selectedDayOfWeek: String?
    
    
    //MARK: Actions
    @IBAction func generateMealPlan(_ sender: UITapGestureRecognizer) {
//        getDataFromServer(url: URL(string: "http://192.168.1.64:3000")!)
        getDataFromServer(url: URL(string: "http://localhost:3000")!)
    }
    
    @IBAction func weekDaySwitcherChanged(_ sender: UISegmentedControl) {
        switch weekDaySwitcher.selectedSegmentIndex {
        case 0:
            selectedDayOfWeek = "Monday"
        case 1:
            selectedDayOfWeek = "Tuesday"
        case 2:
            selectedDayOfWeek = "Wednesday"
        case 3:
            selectedDayOfWeek = "Thursday"
        case 4:
            selectedDayOfWeek = "Friday"
        case 5:
            selectedDayOfWeek = "Saturday"
        case 6:
            selectedDayOfWeek = "Sunday"
        default:
            return
        }
        
        tableView.reloadData()
    }
    
    func weekDayInitialSetup() {
        let today = DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1]
        
        switch today {
        case "Monday":
            selectedDayOfWeek = "Monday"
            weekDaySwitcher.selectedSegmentIndex = 0
        case "Tuesday":
            selectedDayOfWeek = "Tuesday"
            weekDaySwitcher.selectedSegmentIndex = 1
        case "Wednesday":
            selectedDayOfWeek = "Wednesday"
            weekDaySwitcher.selectedSegmentIndex = 2
        case "Thursday":
            selectedDayOfWeek = "Thursday"
            weekDaySwitcher.selectedSegmentIndex = 3
        case "Friday":
            selectedDayOfWeek = "Friday"
            weekDaySwitcher.selectedSegmentIndex = 4
        case "Saturday":
            selectedDayOfWeek = "Saturday"
            weekDaySwitcher.selectedSegmentIndex = 5
        case "Sunday":
            selectedDayOfWeek = "Sunday"
            weekDaySwitcher.selectedSegmentIndex = 6
        default:
            return
        }
    }
    

    func getDataFromServer(url: URL) {
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            
        }
        
        task.resume()
    }
    
    
    //MARK: TableView set up
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("COUNT: \(mealPlan["Saturday"]?.count)")
        return mealPlan[selectedDayOfWeek!]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealCell
        cell.mealTypeLabel.text = mealPlan[selectedDayOfWeek!]?[indexPath.row].mealType
        cell.dishLabel.text = mealPlan[selectedDayOfWeek!]?[indexPath.row].dish
        cell.timeLabel.text = mealPlan[selectedDayOfWeek!]?[indexPath.row].time
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AddMealController
        destinationVC.dayOfWeek = selectedDayOfWeek
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.deleteFromDatabase(mealIdToDelete: (self.mealPlan[self.selectedDayOfWeek!]?[indexPath.row].id)!)
            DispatchQueue.main.async {
                self.mealPlan = [:]
            }
            self.fetchMealPlanFromFirebase()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            completionHandler(true)
        }
        action.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    // MARK: Google Firebase Fetching
    func fetchMealPlanFromFirebase() {
        
        let refBase = Database.database().reference().child("Users").child(String(UserDefaults.standard.string(forKey: "userID")!)).child("MealPlan/")
        let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        
        for day in days {
            
            let ref = refBase.child(day)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.childrenCount > 0 {
                    class MealsForDay { static var array: [Meal] = [] }
                    
                    for child in snapshot.children {
                        
                        let snap = child as! DataSnapshot
                        let value = snap.value! as? NSDictionary
                        let mealItem = Meal(id: snap.key, mealType: value!["mealType"] as! String, dish: value!["dish"] as! String, time: value!["time"] as! String)
                        MealsForDay.array.append(mealItem)
                        self.mealPlan.updateValue(MealsForDay.array, forKey: day)
                    }
                    
                    MealsForDay.array = []
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.spinner.stopAnimating()
                        self.spinner.isHidden = true
                    }
                }
            }
        }
    }
    
    
    //MARK: Deleting from database
    func deleteFromDatabase(mealIdToDelete: String) {
        let databasePath: String = "Users/" + "\(String(describing: UserDefaults.standard.string(forKey: "userID")!))/" + "MealPlan/\(selectedDayOfWeek!)/" + mealIdToDelete
        let ref = Database.database().reference().child(databasePath)
        ref.removeValue()
    }

}
