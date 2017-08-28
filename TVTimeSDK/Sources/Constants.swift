/******************************************************************************
 *
 * Constants.swift
 *
 ******************************************************************************/

import Foundation

public func debugLog(_ object: Any, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
    #if DEBUG
        let className = (fileName as NSString).lastPathComponent
        print("\(className)>: \(functionName) Line: \(lineNumber) - \(object)\n")
    #endif
}

public struct Constants {

    public static let SonarrDateFormatString = "yyyy-MM-dd'T'HH:mm:ssZ"

    public struct Notifications {
        public static let ReachableViaWiFiNotification = Notification.Name("ReachableViaWiFiNotification")
        public static let DoneConfiguringSonarr = Notification.Name("DoneConfiguringSonarr")
        public static let DoneConfiguringCouchPotato = Notification.Name("DoneConfiguringCouchPotato")
        public static let ErrorConfiguringSonarr = Notification.Name("ErrorConfiguringSonarr")
        public static let ErrorConfiguringCouchPotato = Notification.Name("ErrorConfiguringCouchPotato")
        public static let NeedsSetup = Notification.Name("NeedsSetup")
        public static let DoneFindingAuthor = Notification.Name("DoneFindingAuthor")
    }
}

