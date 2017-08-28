/******************************************************************************
 *
 * NetworkActivityIndicatorManager
 *
 ******************************************************************************/

import Foundation
import UIKit

public final class NetworkActivityIndicatorManager {
    
    static var activityCount = 0
    
    public static func incrementActivityCount() {
        
        activityCount += 1

        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    public static func decrementActivityCount() {
        
        activityCount -= 1
        
        if activityCount <= 0 {
            reset()
        }
    }
    
    public static func reset() {
        activityCount = 0
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }

    }
}

