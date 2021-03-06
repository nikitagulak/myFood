//
//  product.swift
//  myFood
//
//  Created by Nick on 19.09.2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ProductItemCollection {
    let product1, product2, product3, product4: ProductItem
}

// MARK: - Product
struct ProductItem {
    let id: String
    let name: String
    let storingPlace: String
    let weight: Int
    let unit: String
    let expiryDate: String
    
    init(id:String, name:String, storingPlace:String, weight:Int, unit:String, expiryDate:String) {
        self.id = id
        self.name = name
        self.weight = weight
        self.unit = unit
        self.storingPlace = storingPlace
        self.expiryDate = expiryDate
    }
    
    init(name:String, storingPlace:String, weight:Int, unit:String, expiryDate:String) {
        self.id = ""
        self.name = name
        self.weight = weight
        self.unit = unit
        self.storingPlace = storingPlace
        self.expiryDate = expiryDate
    }
}
