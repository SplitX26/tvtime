/******************************************************************************
 *
 * MoviesManager
 *
 ******************************************************************************/

import Foundation

public enum MovieSortType {
    case name
    case year
}


public final class MoviesManager {
    
    public static var movieProfiles: MovieProfileList? {
        didSet {
            DispatchQueue.main.async(execute: {
                NotificationCenter.default.post(name: Constants.Notifications.DoneConfiguringCouchPotato, object: nil)
            })
        }
    }
    
    public static func movieProfile(_ id: String?) -> MovieProfile? {
        guard let id = id, let profile = movieProfiles?.list.filter({ $0.id == id }).first else {
            return nil
        }
        return profile
    }

    public static func movieProfilesList() -> [MovieProfile]? {
        return movieProfiles?.list
    }

    public static func profileId(for name: String) -> String? {
        
        guard let profiles = movieProfilesList() else {
            return nil
        }
        
        return profiles.filter({ $0.title.lowercased() == name.lowercased() }).first?.id
    }
}
