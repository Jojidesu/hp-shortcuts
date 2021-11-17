//
//  DishBook.swift
//  RecipeAssistant
//
//  Created by phuong vb on 11/16/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Intents

struct DishModel: Decodable {
    let identifier: String
    let displayString: String
    let price: Decimal?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(String.self, forKey: .identifier)
        displayString = try container.decode(String.self, forKey: .displayString)
        if let priceString = try container.decodeIfPresent(String.self, forKey: .price) {
            price = Decimal(Double(priceString) ?? 0)
        } else {
            price = nil
        }
    }

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case displayString = "name"
        case price = "price"
    }

    var dish: Dish {
        let intentModel = Dish(identifier: identifier, display: displayString)
        intentModel.price = NSDecimalNumber(decimal: price ?? 0)
        return intentModel
    }
}

extension Dish: CaseIterable {

    public typealias AllCases = [Dish]

    public static var allCases: [Dish] {
        (JsonLoader.load(fileName: "restaurants") as [DishModel]).map { $0.dish }
    }
}
