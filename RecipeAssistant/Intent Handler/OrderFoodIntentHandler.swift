//
//  OrderFoodIntentHandler.swift
//  RecipeAssistant
//
//  Created by phuong vb on 11/16/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import Intents

class OrderFoodIntentHandler: NSObject, OrderFoodIntentHandling {
    let displayNumber = 5

    func handle(intent: OrderFoodIntent, completion: @escaping (OrderFoodIntentResponse) -> Void) {
        guard let restaurant = intent.restaurant,
        let dish = intent.dish,
        let quantity = intent.quantity else {
            completion(OrderFoodIntentResponse(code: .failure, userActivity: .orderFail)) //
            return
        }
        let priceDouble = (dish.price?.doubleValue ?? 0) * quantity.doubleValue
        let price = NSNumber(value: priceDouble)
        completion(OrderFoodIntentResponse.summaryOrder(price: price, quantity: quantity, dish: dish, restaurant: restaurant))
    }

    func provideRestaurantOptionsCollection(for intent: OrderFoodIntent, with completion: @escaping (INObjectCollection<Restaurant>?, Error?) -> Void) {
        completion(INObjectCollection(items: Restaurant.allCases), nil)
    }

    func provideDishOptionsCollection(for intent: OrderFoodIntent, with completion: @escaping (INObjectCollection<Dish>?, Error?) -> Void) {
        guard let restaurant = intent.restaurant else {
            return
        }
        let allRestaurantDishes = restaurant.categories?.compactMap { $0.dishes }.flatMap { $0 } ?? []
        let displayDishes = Array(allRestaurantDishes.suffix(displayNumber))

        completion(INObjectCollection(items: displayDishes), nil)
    }

    func resolveQuantity(for intent: OrderFoodIntent, with completion: @escaping (OrderFoodQuantityResolutionResult) -> Void) {
        guard let quantity = intent.quantity else {
            completion(OrderFoodQuantityResolutionResult.success(with: 1))
            return
        }
        completion(OrderFoodQuantityResolutionResult.success(with: quantity.intValue))
    }

    func resolveDish(for intent: OrderFoodIntent, with completion: @escaping (DishResolutionResult) -> Void) {
        guard let dish = intent.dish else {
            let allRestaurantDishes = intent.restaurant?.categories?.compactMap { $0.dishes }.flatMap { $0 } ?? []
            let displayDishes = Array(allRestaurantDishes.suffix(displayNumber))
            completion(DishResolutionResult.disambiguation(with: displayDishes))
            return
        }
        completion(DishResolutionResult.success(with: dish))
    }

    func resolveRestaurant(for intent: OrderFoodIntent, with completion: @escaping (RestaurantResolutionResult) -> Void) {
        guard let restaurant = intent.restaurant else {
            completion(RestaurantResolutionResult.disambiguation(with: Restaurant.allCases))
            return
        }
        completion(RestaurantResolutionResult.success(with: restaurant))
    }
}
