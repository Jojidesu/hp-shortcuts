//
//  CategoryBook.swift
//  RecipeAssistant
//
//  Created by phuong vb on 11/16/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import Intents

struct CategoryModel: Decodable {
    let identifier: String
    let displayString: String
    let dishes: [DishModel]?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(String.self, forKey: .identifier)
        displayString = try container.decode(String.self, forKey: .displayString)
        dishes = try container.decodeIfPresent(Array<DishModel>.self, forKey: .dishes)
    }

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case displayString = "name"
        case dishes = "items"
    }

    var category: Category {
        let intentModel = Category(identifier: identifier, display: displayString)
        intentModel.dishes = dishes?.map { $0.dish }
        return intentModel
    }
}

extension Category: CaseIterable {

    public typealias AllCases = [Category]

    public static var allCases: [Category] {
        (JsonLoader.load(fileName: "restaurants") as [CategoryModel]).map { $0.category }
    }
}
