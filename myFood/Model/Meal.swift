//
//  Meal.swift
//  myFood
//
//  Created by Nick on 28/11/2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import Foundation

struct Meal {
    let id: String
    let mealType: String
    let dish: String
    let time: String
    
    init(id:String, mealType:String, dish:String, time:String) {
        self.id = id
        self.mealType = mealType
        self.dish = dish
        self.time = time
    }
}
