/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Convenience utility for working with NSUserActivity.
*/

import Foundation
import UniformTypeIdentifiers

#if canImport(CoreSpotlight)
    import CoreSpotlight
    import UIKit
#endif

extension NSUserActivity {
    public enum ActivityKeys: String {
        case orderID
    }

    public static let orderCompleteActivityType = "com.example.HuntingParty.orderComplete"
    public static let orderFailActivityType = "com.example.HuntingParty.orderFail"
    
    public static var orderFail: NSUserActivity {
        let userActivity = NSUserActivity(activityType: NSUserActivity.orderFailActivityType)

        userActivity.title = "Fail to order"
        userActivity.isEligibleForPrediction = true
        
    #if canImport(CoreSpotlight)
        let attributes = CSSearchableItemAttributeSet(contentType: UTType.content)
        
        attributes.thumbnailData = #imageLiteral(resourceName: "tomato").pngData() // Used as an icon in Search.
        attributes.keywords = ["Order", "Soup", "Menu"]
        attributes.displayName = "Fail to order"
        attributes.contentDescription = "Continue order in app"
        
        userActivity.contentAttributeSet = attributes
    #endif
        
        let phrase = "Order foodpanda"
        userActivity.suggestedInvocationPhrase = phrase
        return userActivity
    }

}
