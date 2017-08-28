/******************************************************************************
 *
 * Settings
 *
 ******************************************************************************/

import Foundation
import WatchConnectivity

public final class Settings: NSObject, NSCoding {
    
    public struct Keys {
        static let product = "product"
        static let api = "api"
        static let host = "host"
    }
    
    public var host: String
    public var api: String
    public var product: Product
    
    required convenience public init?(coder aDecoder: NSCoder) {
        
        guard let host = aDecoder.decodeObject(forKey: Keys.host) as? String,
            let api = aDecoder.decodeObject(forKey: Keys.api) as? String,
            let prd = aDecoder.decodeObject(forKey: Keys.product) as? String,
            let product = Product(rawValue: prd) else {
                return nil
        }
        
        self.init(product: product, host: host, api: api)
    }
    
    public init(product: Product, host: String, api: String) {
        self.product = product
        self.api = api
        self.host = host
    }
    
    public convenience init?(dictionary: JSONDict) {
        
        guard let host = dictionary[Keys.host] as? String,
            let api = dictionary[Keys.api] as? String,
            let prd = dictionary[Keys.product] as? String,
            let product = Product(rawValue: prd) else {
                return nil
        }
        
        self.init(product: product, host: host, api: api)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(host, forKey: Keys.host)
        aCoder.encode(api, forKey: Keys.api)
        aCoder.encode(product.rawValue, forKey: Keys.product)
    }
    
    public func saveToUserDefaults() {
        UserDefaults.standard.set(toData(), forKey: product.rawValue)
        UserDefaults.standard.synchronize()        
    }
    
    public class func remove(product: Product) {
        UserDefaults.standard.removeObject(forKey: product.rawValue)
    }
    
    public convenience init?(_ product: Product) {
        
        guard let data = UserDefaults.standard.object(forKey: product.rawValue) as? Data,
            let defaults = NSKeyedUnarchiver.unarchiveObject(with: data) as? Settings else {
                return nil
        }
        
        self.init(product: product, host: defaults.host, api: defaults.api)
    }
    
    func toData() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }
    
    public static func exist() -> Bool {
        
        return Settings(.sonarr) != nil &&
            Settings(.couchPotato) != nil &&
            Settings(.headphones) != nil &&
            Settings(.lazyLibrarian) != nil
    }
}

extension Settings: DictionaryRepresentationProtocol {
    
    public func toDictionary() -> JSONDict {
        
        var dictionary: JSONDict = [:]
        
        dictionary.updateValue(product.rawValue, forKey: Keys.product)
        dictionary.updateValue(host, forKey: Keys.host)
        dictionary.updateValue(api, forKey: Keys.api)
        
        return dictionary
    }
}
