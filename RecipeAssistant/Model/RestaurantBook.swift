//
//  RestaurantBook.swift
//  RecipeAssistant
//
//  Created by phuong vb on 11/16/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import Intents

struct RestaurantModel: Decodable {
    let identifier: String
    let displayString: String
    let address: String?
    let cuisine: [String]?
    let promotion: String?
    let categories: [CategoryModel]?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(String.self, forKey: .identifier)
        displayString = try container.decode(String.self, forKey: .displayString)
        address = try container.decodeIfPresent(String.self, forKey: .address)
        cuisine = try container.decodeIfPresent(Array<String>.self, forKey: .cuisine)
        promotion = try container.decodeIfPresent(String.self, forKey: .promotion)
        categories = try container.decodeIfPresent(Array<CategoryModel>.self, forKey: .categories)
    }

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case displayString = "restaurant_name"
        case address
        case cuisine = "cuisine_type"
        case promotion
        case categories = "categories"
    }

    var restaurant: Restaurant {
        let intentModel = Restaurant(identifier: identifier, display: displayString)
        intentModel.address = address
        intentModel.cuisine = cuisine
        intentModel.promotion = promotion
        intentModel.categories = categories?.map { $0.category }
        return intentModel
    }
}

class Restaurants: Decodable {
    let restaurants: [RestaurantModel]
}

extension Restaurant: CaseIterable {

    public typealias AllCases = [Restaurant]

    public static var allCases: [Restaurant] {
        let result = (JsonLoader.load(fileName: "restaurants") as Restaurants)
            .restaurants
            .map { $0.restaurant }
        print(result)
        return result
//        stubs
    }

    static var stubs: [Restaurant] {
        [
            restaurant,
            restaurant,
            restaurant,
            restaurant
        ]
    }

    static var restaurant: Restaurant {
        let result = Restaurant(identifier: "any", display: "any")
        result.address = "address"
        result.cuisine = ["cuisine"]
        result.promotion = "promotion"
        result.categories = [category, category, category, category]
        return result
    }

    static var category: Category {
        let result = Category(identifier: "any", display: "any")
        result.dishes = [dish, dish, dish]
        return result
    }

    static var dish: Dish {
        let result = Dish(identifier: "any", display: "any")
        result.price = 0.3
        return result
    }
}
