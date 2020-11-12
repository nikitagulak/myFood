//
//  ProductTableViewCell.swift
//  myFood
//
//  Created by Nick on 19.09.2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var expiryDate: UILabel!
    @IBOutlet weak var clockIcon: UIImageView!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
