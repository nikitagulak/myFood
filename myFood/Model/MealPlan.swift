//
//  MealPlan.swift
//  myFood
//
//  Created by Nick on 04/01/2021.
//  Copyright © 2021 Nikita Gulak. All rights reserved.
//

import Foundation

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
    let meals: [MealItem]?
    let nutrients: Nutrients?
}

// MARK: - Meal
struct MealItem: Codable {
    let id: Int?
    let imageType: ImageType?
    let title: String?
    let readyInMinutes, servings: Int?
    let sourceURL: String?

    enum CodingKeys: String, CodingKey {
        case id, imageType, title, readyInMinutes, servings
        case sourceURL = "sourceUrl"
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


