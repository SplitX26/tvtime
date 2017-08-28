/******************************************************************************
 *
 * Product.swift
 *
 ******************************************************************************/

import UIKit

public enum Product: String {
    case couchPotato = "CouchPotato"
    case sonarr = "Sonarr"
    case headphones = "Headphones"
    case lazyLibrarian = "LazyLibrarian"
    case sabnzbd = "SABnzbd"
    case settings = "Settings"
    
    public static let allValues = [sonarr, couchPotato, headphones, lazyLibrarian, sabnzbd]
        
    public func isConfigured() -> Bool {
        
        var retVal = false

        switch self {
        case .couchPotato: fallthrough
        case .sonarr: fallthrough
        case .headphones: fallthrough
        case .lazyLibrarian: fallthrough
        case .sabnzbd:
            retVal = Settings(self) != nil
        case .settings:
            retVal = true
        }
        
        return retVal
    }
    
    public func hostURLString() -> String? {
        
        switch self {
        case .sonarr: fallthrough
        case .couchPotato: fallthrough
        case .headphones: fallthrough
        case .lazyLibrarian: fallthrough
        case .sabnzbd:
            return Settings(self)?.host
        default:
            return nil
        }
    }
    
    public func hostURL() -> URL? {
        guard let urlString = hostURLString() else {
            return nil
        }
        
        return URL(string: urlString)
    }
    
    func baseURL() -> String? {
        
        let defaults = Settings(self)

        switch self {
        case .couchPotato:
            return String(format:"%@/api/%@", defaults?.host ?? "", defaults?.api ?? "")
        case .sonarr:
            return defaults?.host
        case .headphones:
            return String(format:"%@/api?apikey=%@&cmd=", defaults?.host ?? "", defaults?.api ?? "")
        case .lazyLibrarian:
            return String(format:"%@/api?apikey=%@&cmd=", defaults?.host ?? "", defaults?.api ?? "")
        case .sabnzbd:
            return String(format:"%@/sabnzbd/api?output=json&apikey=%@&mode=", defaults?.host ?? "", defaults?.api ?? "")
        default:
            return nil
        }
    }
}
