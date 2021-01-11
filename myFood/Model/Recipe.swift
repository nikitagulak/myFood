//
//  Recipe.swift
//  myFood
//
//  Created by Nick on 10/01/2021.
//  Copyright © 2021 Nikita Gulak. All rights reserved.
//

import Foundation

// MARK: - WelcomeElement
struct Recipe: Codable {
    let id: Int?
    let title: String?
    let image: String?
    let imageType: ImageType?
    let usedIngredientCount, missedIngredientCount: Int?
    let missedIngredients, usedIngredients, unusedIngredients: [SedIngredient]?
    let likes: Int?
}


// MARK: - SedIngredient
struct SedIngredient: Codable {
    let id: Int?
    let amount: Double?
    let unit, unitLong, unitShort, aisle: String?
    let name, original, originalString, originalName: String?
    let metaInformation, meta: [String]?
    let image: String?
    let extendedName: String?
}

typealias Recipes = [Recipe]
