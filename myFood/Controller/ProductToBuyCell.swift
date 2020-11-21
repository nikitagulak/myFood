//
//  ProductToBuyCell.swift
//  myFood
//
//  Created by Nick on 21/11/2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import UIKit

final class ProductToBuyCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var checkbox: UIButton!
    
    @IBAction func didTapButton(_ sender: UIButton) {
        actionBlock?()
    }
    
    var actionBlock: (() -> Void)? = nil
}
