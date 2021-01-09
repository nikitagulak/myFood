//
//  MealPlanResponseController.swift
//  myFood
//
//  Created by Nick on 09/01/2021.
//  Copyright © 2021 Nikita Gulak. All rights reserved.
//

import UIKit

class MealPlanResponseController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let rightBarButtonItem = UIBarButtonItem()
        rightBarButtonItem.title = "Save"
        rightBarButtonItem.tintColor = UIColor.systemGreen
        rightBarButtonItem.target = self
        rightBarButtonItem.action = #selector(savePlan)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        print(parameters)
        generateMealPlanRequest(targetCalories: parameters["targetCalories"] ?? "", diet: parameters["diet"] ?? "", exclude: parameters["exclude"] ?? "")
    }
    
    // MARK: Instances
    @IBOutlet weak var nameCellLabel: UILabel!
    
    var parameters = [String:String]()
    var mealPlan: MealPlan?
    
    @objc public func savePlan(sender: UIBarButtonItem) {
//        let nextViewController = storyboard?.instantiateViewController(identifier: "dietCV") as! DietViewController
//        self.present(nextViewController, animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 7
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealPlanResponseCell", for: indexPath) as! MealResponseCell

//        cell.title.text = "Hello World Hello World Hello World Hello World Hello World"
        cell.title.text = mealPlan?.week?.monday?.meals?[indexPath.row].title
        cell.title.numberOfLines = 0
        cell.title.lineBreakMode = .byWordWrapping
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Monday"
        case 1:
            return "Tuesday"
        case 2:
            return "Wednesday"
        case 3:
            return "Thursday"
        case 4:
            return "Friday"
        case 5:
            return "Saturday"
        case 6:
            return "Sunday"
        default:
            return ""
        }
    }
    
    // MARK: Get data from Spoonacular API
    func generateMealPlanRequest(targetCalories: String, diet: String, exclude: String) {
        let apiKey = "c9048153061a4a4fa5d14861e1740e74"
        let url = "https://api.spoonacular.com/mealplanner/generate?apiKey=\(apiKey)&timeFrame=week&targetCalories=\(targetCalories)&diet=\(diet)&exclude=\(exclude)"
//        print(url)
        if let urlObj = URL(string: url) {
          URLSession.shared.dataTask(with: urlObj) {(data, response, error) in
            do {
                let decodedMealPlan = try JSONDecoder().decode(MealPlan.self, from: data!)
//                print(decodedMealPlan.week?.monday?.meals?[0])
                self.mealPlan = decodedMealPlan
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
              print("Error of decoding JSON: \(error)")
            }
          }.resume()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var links = [String]()
        
        for meal in mealPlan!.week!.monday!.meals! {
            links.append(meal.sourceURL!)
        }
        for meal in mealPlan!.week!.tuesday!.meals! {
            links.append(meal.sourceURL!)
        }
        for meal in mealPlan!.week!.wednesday!.meals! {
            links.append(meal.sourceURL!)
        }
        for meal in mealPlan!.week!.thursday!.meals! {
            links.append(meal.sourceURL!)
        }
        for meal in mealPlan!.week!.friday!.meals! {
            links.append(meal.sourceURL!)
        }
        for meal in mealPlan!.week!.saturday!.meals! {
            links.append(meal.sourceURL!)
        }
        for meal in mealPlan!.week!.sunday!.meals! {
            links.append(meal.sourceURL!)
        }
        
        if let url = URL(string: (links[indexPath.row])) {
            UIApplication.shared.open(url)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
