//
//  RestaurantIndentHandler.swift
//  RecipeAssistant
//
//  Created by phuong vb on 11/16/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import Intents

class RestaurantIntentHandler: NSObject, SelectRestaurantIntentHandling {
    var currentRestaurant: Restaurant?
    weak var nextStepProvider: RestaurantNextStepProviding?

    func handle(intent: SelectRestaurantIntent, completion: @escaping (SelectRestaurantIntentResponse) -> Void) {
        guard let restaurant = restaurant(for: intent),
              let nextStepProvider = self.nextStepProvider,
              UIApplication.shared.applicationState != .background else {
            completion(SelectRestaurantIntentResponse(code: .continueInApp, userActivity: nil))
            return
        }
        completion(nextStepProvider.nextStep(restaurant: restaurant))
    }

    func resolveRestaurant(for intent: SelectRestaurantIntent, with completion: @escaping (RestaurantResolutionResult) -> Void) {
        guard let restaurant = restaurant(for: intent) else {
            completion(RestaurantResolutionResult.disambiguation(with: Restaurant.allCases))
            return
        }
        completion(RestaurantResolutionResult.success(with: restaurant))
    }

    func provideRestaurantOptionsCollection(for intent: SelectRestaurantIntent, with completion: @escaping (INObjectCollection<Restaurant>?, Error?) -> Void) {
        completion(INObjectCollection(items: Restaurant.allCases), nil)
    }

    private func restaurant(for intent: SelectRestaurantIntent) -> Restaurant? {
        return currentRestaurant != nil ? currentRestaurant : intent.restaurant
    }
}

protocol RestaurantNextStepProviding: NSObject {

    /// The intent handler object processes resolve, confirm, and handle phases.
    var intentHandler: RestaurantIntentHandler { get }

    /// When the intent handler is ready to advance to the next step, the app calls the `nextStep` method.
    @discardableResult
    func nextStep(restaurant: Restaurant) -> SelectRestaurantIntentResponse

}
