//
//  ExploreRecipesController.swift
//  myFood
//
//  Created by Nick on 05/01/2021.
//  Copyright © 2021 Nikita Gulak. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ExploreRecipesController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        generateRecipes()
        
        // Spinner
        spinner.center = self.view.center
        self.view.addSubview(spinner)
        spinner.startAnimating()
    }
    

    // MARK: Instance variables
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var ingredients: String?
    var recipes: Recipes?
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell

        if recipes != nil {
            // Number of ingredients
            cell.ingredientsAmount.text = "\(recipes![indexPath.row].missedIngredientCount! + recipes![indexPath.row].usedIngredientCount!) ingredients"
            
            // Recipe's name
            cell.recipeName.text = recipes?[indexPath.row].title
            
            // Recipe's picture
            let url = URL(string: recipes![indexPath.row].image!)
            if let image = try? Data(contentsOf: url!) {
                cell.picture.image = UIImage(data: image)
            }
            
        }
        
        return cell
    }
    
    
    // MARK: Get data from Spoonacular API
    func generateRecipes() {
        let apiKey = "c9048153061a4a4fa5d14861e1740e74"
        let url = "https://api.spoonacular.com/recipes/findByIngredients?apiKey=\(apiKey)&number=10&ingredients=\(ingredients!)"
//        print(url)
        if let urlObj = URL(string: url) {
          URLSession.shared.dataTask(with: urlObj) {(data, response, error) in
            do {
                let decodedRecipes = try JSONDecoder().decode(Recipes.self, from: data!)
                self.recipes = decodedRecipes
                self.tableView.reloadData()
                self.spinner.removeFromSuperview()
            } catch {
              print("Error of decoding JSON: \(error)")
            }
          }.resume()
        }
    }
    
    
    func getInformationByRecipeId(id: Int) {
        let apiKey = "c9048153061a4a4fa5d14861e1740e74"
        let url = "https://api.spoonacular.com/recipes/\(id)/information?apiKey=\(apiKey)&includeNutrition=false"
        print(url)
        if let urlObj = URL(string: url) {
          URLSession.shared.dataTask(with: urlObj) {(data, response, error) in
            do {
                let decodedInfo = try JSONDecoder().decode(RecipeInfo.self, from: data!)
                
                if let url = URL(string: decodedInfo.sourceURL!) {
                    UIApplication.shared.open(url)
                }
                
                self.tableView.reloadData()
            } catch {
              print("Error of decoding JSON: \(error)")
            }
          }.resume()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        getInformationByRecipeId(id: recipes![indexPath.row].id!)
        
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
