//
//  ShoppingListViewCell.swift
//  myFood
//
//  Created by Nick on 21/11/2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import UIKit

class ShoppingListCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var listNameLabel: UILabel!
    
}
