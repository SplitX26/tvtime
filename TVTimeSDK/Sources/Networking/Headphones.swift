/******************************************************************************
 *
 * Headphones
 *
 ******************************************************************************/

import Foundation

public final class Headphones: Networking {
    
    private struct ServiceKeys {
        static let findArtist = "findArtist"
        static let getArtistArt = "getArtistArt"
        static let addArtist = "addArtist"
        static let getArtist = "getArtist"
        static let queueAlbum = "queueAlbum"
    }
    
    private static let ServerPaths = [
        ServiceKeys.findArtist: "findArtist&name=%@",
        ServiceKeys.getArtistArt: "getArtistArt&id=%@",
        ServiceKeys.addArtist: "addArtist&id=%@",
        ServiceKeys.getArtist: "getArtist&id=%@",
        ServiceKeys.queueAlbum: "queueAlbum&id=%@"
    ]
    
    public static func searchArtist(_ term: String, success: (([ArtistSearchResult]) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode([ArtistSearchResult].self, from: data)
            } catch {
                return [ArtistSearchResult]()
            }
        }
                
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! [ArtistSearchResult])
            } else {
                if let failure = failure {
                    failure(NSError(domain: TVTime, code: 99, userInfo: [NSLocalizedDescriptionKey : "No Results Found"]))
                }
            }
        }
        
        performGetRequest(product: .headphones, pathDictionary: ServerPaths, key: ServiceKeys.findArtist, parameters: [term], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func addArtist(_ artistSearchResult: ArtistSearchResult, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (string: String) -> Any? in
            return string
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                if let foo = results as? String, foo == "OK" {
                    success(true)
                } else {
                    success(false)
                }
            } else {
                if let failure = failure {
                    failure(NSError(domain: TVTime, code: 99, userInfo: [NSLocalizedDescriptionKey : "noResultsFound"]))
                }
            }
        }
        
        let _ = performGetRequest(product: .headphones, pathDictionary: ServerPaths, key: ServiceKeys.addArtist, parameters: [artistSearchResult.id], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func getArtist(_ artistSearchResult: ArtistSearchResult, success: ((MetaArtist?) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode(MetaArtist.self, from: data)
            } catch {
                return error
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            
            if let results = results as? MetaArtist {
                if let success = success {
                    success(results)
                }
            } else {
                if let failure = failure {
                    failure(results as! Error)
                }
            }
        }
        
        performGetRequest(product: .headphones, pathDictionary: ServerPaths, key: ServiceKeys.getArtist, parameters: [artistSearchResult.id], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func getArtistArt(_ id: String, success: ((URL?) -> Void)?, failure: ((Error) -> Void)?) -> Int? {
        
        let parseBlock = { (string: String) -> Any? in
            return string
        }
        
        let successBlock = { (results: Any?) -> Void in
            
            guard let urlString = results as? String else {
                if let failure = failure {
                    failure(NSError(domain: TVTime, code: 99, userInfo: [NSLocalizedDescriptionKey : "noResultsFound"]))
                }
                return
            }
            
            if urlString.hasPrefix("cache") {
                if let success = success {
                    success(URL(string: urlString, relativeTo: Product.headphones.hostURL()))
                }
            } else {
                if let success = success {
                    success(URL(string: urlString))
                }
            }
        }
        
        return performGetRequest(product: .headphones, pathDictionary: ServerPaths, key: ServiceKeys.getArtistArt, parameters: [id], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func queueAlbum(_ id: String, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (string: String) -> Any? in
            return string
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                if let foo = results as? String, foo == "OK" {
                    success(true)
                } else {
                    success(false)
                }
            } else {
                if let failure = failure {
                    failure(NSError(domain: TVTime, code: 99, userInfo: [NSLocalizedDescriptionKey : "noResultsFound"]))
                }
            }
        }
        
        let _ = performGetRequest(product: .headphones, pathDictionary: ServerPaths, key: ServiceKeys.queueAlbum, parameters: [id], parse: parseBlock, success: successBlock, failure: failure)
    }
}
