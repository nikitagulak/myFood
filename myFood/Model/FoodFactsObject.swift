//
//  FoodFactsObject.swift
//  myFood
//
//  Created by Nick on 22/12/2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import Foundation
import AnyCodable

//struct FoodFactsObject {
//    let name: String
//    let weigth: Int
//    let weightMesureType: String
//    let storingPlace: String
//    let expireDate: Date?
//    let barcode: String?
//}


// MARK: - FoodFactsEntryPoint
struct FoodFactsEntryPoint: Codable {
    let status: Int?
    let statusVerbose, code: String?
    let product: FoodFactsObject?

    enum CodingKeys: String, CodingKey {
        case status
        case statusVerbose = "status_verbose"
        case code, product
    }
}

// MARK: - FoodFactsObject
struct FoodFactsObject: Codable {
    let brands, ingredientsTextPl: String?
    let imageSmallURL: String?
    let quantity: String?
    let additivesTags, ingredientsAnalysisTags: [String]?
    let imageFrontURL: String?
    let nutrientLevels: NutrientLevels?
    let productNamePl, allergens: String?
    let nutriments: Nutriments?
    let imageFrontSmallURL: String?
    let ingredients: [Ingredient]?
    let allergensFromIngredients: String?
    let allergensTags: [String]?
    let traces, nutritionDataPer, productName: String?
    let productQuantity: AnyCodable?
    let imageURL: String?
    let allergensHierarchy: [String]?

    enum CodingKeys: String, CodingKey {
        case brands
        case ingredientsTextPl = "ingredients_text_pl"
        case imageSmallURL = "image_small_url"
        case quantity
        case additivesTags = "additives_tags"
        case ingredientsAnalysisTags = "ingredients_analysis_tags"
        case imageFrontURL = "image_front_url"
        case nutrientLevels = "nutrient_levels"
        case productNamePl = "product_name_pl"
        case allergens, nutriments
        case imageFrontSmallURL = "image_front_small_url"
        case ingredients
        case allergensFromIngredients = "allergens_from_ingredients"
        case allergensTags = "allergens_tags"
        case traces
        case nutritionDataPer = "nutrition_data_per"
        case productName = "product_name"
        case productQuantity = "product_quantity"
        case imageURL = "image_url"
        case allergensHierarchy = "allergens_hierarchy"
    }
}

// MARK: - Ingredient
struct Ingredient: Codable {
    let rank: Int?
    let text, id: String?
    let vegetarian, vegan: HasSubIngredients?
    let percent: String?
    let hasSubIngredients: HasSubIngredients?

    enum CodingKeys: String, CodingKey {
        case rank, text, id, vegetarian, vegan, percent
        case hasSubIngredients = "has_sub_ingredients"
    }
}

enum HasSubIngredients: String, Codable {
    case maybe = "maybe"
    case no = "no"
    case yes = "yes"
}

// MARK: - NutrientLevels
struct NutrientLevels: Codable {
    let fat, sugars, salt, saturatedFat: String?

    enum CodingKeys: String, CodingKey {
        case fat, sugars, salt
        case saturatedFat = "saturated-fat"
    }
}

// MARK: - Nutriments
struct Nutriments: Codable {
    let carbohydratesValue: Double?
    let carbonFootprintFromKnownIngredientsServing: Double?
    let nutritionScoreFrServing, energyKcal100G, nutritionScoreFr100G, carbonFootprintFromKnownIngredients100G: Double?
    let sugarsServing, fiberServing: Double?
    let energy: Int?
    let proteins100G: Double?
    let energyKcalUnit: String?
    let energyServing, nutritionScoreFr, carbonFootprintFromKnownIngredientsProduct: Int?
    let proteinsServing: Double?
    let energyKcalValue: Int?
    let fatUnit: String?
    let energyValue: Int?
    let sugars100G: Double?
    let sugarsUnit: String?
    let proteins: Double?
    let carbohydrates100G: Double?
    let fiberUnit: String?
    let salt100G, saturatedFat: Double?
    let carbohydratesUnit: String?
    let sodiumServing: Double?
    let saltUnit: String?
    let fat: Double?
    let carbohydratesServing, sodiumValue: Double?
    let sugarsValue: Double?
    let sodium, saltValue, fiber, fiber100G: Double?
    let fatValue, novaGroup100G: Int?
    let salt: Double?
    let carbohydrates: Double?
    let fatServing: Double?
    let fat100G: Double?
    let saturatedFatValue: Double?
    let energy100G, sugars: Double?
    let saturatedFat100G, proteinsValue: Double?
    let novaGroup: Int?
    let saturatedFatServing: Double?
    let proteinsUnit, energyUnit: String?
    let energyKcalServing: Double?
    let energyKcal, novaGroupServing: Int?
    let saturatedFatUnit, sodiumUnit: String?
    let sodium100G, fiberValue, saltServing: Double?
    let fruitsVegetablesNutsEstimateFromIngredients100G: Int?

    enum CodingKeys: String, CodingKey {
        case carbohydratesValue = "carbohydrates_value"
        case carbonFootprintFromKnownIngredientsServing = "carbon-footprint-from-known-ingredients_serving"
        case nutritionScoreFrServing = "nutrition-score-fr_serving"
        case energyKcal100G = "energy-kcal_100g"
        case nutritionScoreFr100G = "nutrition-score-fr_100g"
        case carbonFootprintFromKnownIngredients100G = "carbon-footprint-from-known-ingredients_100g"
        case sugarsServing = "sugars_serving"
        case fiberServing = "fiber_serving"
        case energy
        case proteins100G = "proteins_100g"
        case energyKcalUnit = "energy-kcal_unit"
        case energyServing = "energy_serving"
        case nutritionScoreFr = "nutrition-score-fr"
        case carbonFootprintFromKnownIngredientsProduct = "carbon-footprint-from-known-ingredients_product"
        case proteinsServing = "proteins_serving"
        case energyKcalValue = "energy-kcal_value"
        case fatUnit = "fat_unit"
        case energyValue = "energy_value"
        case sugars100G = "sugars_100g"
        case sugarsUnit = "sugars_unit"
        case proteins
        case carbohydrates100G = "carbohydrates_100g"
        case fiberUnit = "fiber_unit"
        case salt100G = "salt_100g"
        case saturatedFat = "saturated-fat"
        case carbohydratesUnit = "carbohydrates_unit"
        case sodiumServing = "sodium_serving"
        case saltUnit = "salt_unit"
        case fat
        case carbohydratesServing = "carbohydrates_serving"
        case sodiumValue = "sodium_value"
        case sugarsValue = "sugars_value"
        case sodium
        case saltValue = "salt_value"
        case fiber
        case fiber100G = "fiber_100g"
        case fatValue = "fat_value"
        case novaGroup100G = "nova-group_100g"
        case salt, carbohydrates
        case fatServing = "fat_serving"
        case fat100G = "fat_100g"
        case saturatedFatValue = "saturated-fat_value"
        case energy100G = "energy_100g"
        case sugars
        case saturatedFat100G = "saturated-fat_100g"
        case proteinsValue = "proteins_value"
        case novaGroup = "nova-group"
        case saturatedFatServing = "saturated-fat_serving"
        case proteinsUnit = "proteins_unit"
        case energyUnit = "energy_unit"
        case energyKcalServing = "energy-kcal_serving"
        case energyKcal = "energy-kcal"
        case novaGroupServing = "nova-group_serving"
        case saturatedFatUnit = "saturated-fat_unit"
        case sodiumUnit = "sodium_unit"
        case sodium100G = "sodium_100g"
        case fiberValue = "fiber_value"
        case saltServing = "salt_serving"
        case fruitsVegetablesNutsEstimateFromIngredients100G = "fruits-vegetables-nuts-estimate-from-ingredients_100g"
    }
}
