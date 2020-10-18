//
//  product.swift
//  myFood
//
//  Created by Nick on 19.09.2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import Foundation

struct Product {
    let name: String
    let weigth: Int
    let weightMesureType: String
    let storingPlace: String
    let expireDate: Date?
    let barcode: String?
}


// MARK: - Welcome
struct ProductItemCollection {
    let product1, product2, product3, product4: ProductItem
}

// MARK: - Product
struct ProductItem {
    let name: String
    let storingPlace: String
    let weight: Int
    let weightMesureType: String
    
    init(name:String, storingPlace:String, weight:Int, weightMesureType:String) {
        self.name = name
        self.weight = weight
        self.weightMesureType = weightMesureType
        self.storingPlace = storingPlace
    }
}
