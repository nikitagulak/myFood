//
//  Meal.swift
//  myFood
//
//  Created by Nick on 28/11/2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import Foundation
import AnyCodable

struct Meal {
    let id: AnyCodable
    var mealType: String?
    let dish: String
    var time: String?
    var link: String?
    
    init(id:AnyCodable, mealType:String, dish:String, time:String, link:String?) {
        self.id = id
        self.mealType = mealType
        self.dish = dish
        self.time = time
        self.link = link
    }
    
    init(id:AnyCodable, dish:String, link:String?) {
        self.id = id
        self.dish = dish
        self.link = link
    }
}


/*
// MARK: - Welcome
struct MealPlan: Codable {
    let week: Week?
}

// MARK: - Week
struct Week: Codable {
    let monday, tuesday, wednesday, thursday: Day?
    let friday, saturday, sunday: Day?
}

// MARK: - Day
struct Day: Codable {
    let meals: [Meal]?
    let nutrients: Nutrients?
}

// MARK: - Meal
struct Meal: Codable {
    let id: AnyCodable
    let mealType: String
    let dish: String
    let time: String
    
    enum CodingKeys: String, CodingKey {
        case id, mealType, time
        case dish = "title"
        
    }
    
    init(id:AnyCodable, mealType:String, dish:String, time:String) {
        self.id = id
        self.mealType = mealType
        self.dish = dish
        self.time = time
    }
}

enum ImageType: String, Codable {
    case jpeg = "jpeg"
    case jpg = "jpg"
}

// MARK: - Nutrients
struct Nutrients: Codable {
    let calories, protein, fat, carbohydrates: Double?
}
*/
