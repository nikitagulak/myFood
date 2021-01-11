//
//  RecipeCell.swift
//  myFood
//
//  Created by Nick on 10/01/2021.
//  Copyright © 2021 Nikita Gulak. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var ingredientsAmount: UILabel!
    

}
