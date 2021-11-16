/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The application delegate.
*/

import UIKit
import Intents

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var selectRestaurant: RestaurantIntentHandler? = RestaurantIntentHandler()
    lazy var orderFood: OrderFoodIntentHandler? = OrderFoodIntentHandler()
    var window: UIWindow?
    
    func application(_ application: UIApplication, handlerFor intent: INIntent) -> Any? {
        switch intent {
        case intent as ShowDirectionsIntent:
            // Each view controller in this app assigns the current intent handler in `viewDidAppear`.
            //
            // If the app doesn't have any UIScenes connected to it, the `currentIntentHandler` is `nil`,
            // so create a new intent handler.
            return AppIntentHandler.shared.currentIntentHandler ?? IntentHandler()
        case intent as SelectRestaurantIntent:
            return selectRestaurant
        case intent as OrderFoodIntent:
            return orderFood
//        case intent as SelectCategoryIntent:
//        case intent as SelectDishIntent:
//        case intent as SelectQuantityIntent:
        default:
            return nil
        }
    }
    
    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}
