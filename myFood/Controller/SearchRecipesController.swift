//
//  SearchRecipesController.swift
//  myFood
//
//  Created by Nick on 10/01/2021.
//  Copyright © 2021 Nikita Gulak. All rights reserved.
//

import UIKit

class SearchRecipesController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Instance variables
    @IBOutlet weak var ingredientsField: UITextField!
    
    
    // MARK: Actions
    @IBAction func getRecipesButton(_ sender: UIButton) {
    
        let destinationVC = storyboard!.instantiateViewController(withIdentifier: "exploreRecipesCV") as! ExploreRecipesController
        
        if let ingredients = ingredientsField.text {
            destinationVC.ingredients = ingredients
        }
        
        navigationController?.pushViewController(destinationVC, animated: true)
    
    }
}
