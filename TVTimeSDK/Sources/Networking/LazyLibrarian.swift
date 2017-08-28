/******************************************************************************
 *
 * Headphones
 *
 ******************************************************************************/

import Foundation

public final class LazyLibrarian: Networking {
    
    public struct Keys {
        static let books = "books"
    }
    
    private struct ServiceKeys {
        static let getAuthorsKey = "getIndex"
        static let getBooksKey = "getBooks"
        static let findAuthorKey = "findAuthor"
        static let findBookKey = "findBook"
        static let addAuthorKey = "addAuthor"
        static let addBookKey = "addBook"
        static let delBookKey = "delBook"
        static let delAuthorKey = "delAuthor"
        static let refreshAuthorKey = "refreshAuthor"
    }
    
    private static let ServerPaths = [
        ServiceKeys.getAuthorsKey: "getIndex",
        ServiceKeys.getBooksKey: "getAuthor&id=%@",
        ServiceKeys.findAuthorKey: "findAuthor&name=%@",
        ServiceKeys.findBookKey: "findBook&name=%@",
        ServiceKeys.addAuthorKey: "addAuthorID&id=%@",
        ServiceKeys.addBookKey: "queueBook&id=%@",
        ServiceKeys.delBookKey: "unqueueBook&id=%@",
        ServiceKeys.delAuthorKey: "removeAuthor&id=%@",
        ServiceKeys.refreshAuthorKey: "refreshAuthor&name=%@"
    ]
    
    public static func authors(_ success: (([Author]) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode([Author].self, from: data)
            } catch {
                return error
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            
            if let results = results as? [Author] {
                if let success = success {
                    success(results)
                }
            } else {
                if let failure = failure {
                    failure(results as! Error)
                }
            }
        }
        
        performGetRequest(product: .lazyLibrarian, pathDictionary: ServerPaths, key: ServiceKeys.getAuthorsKey, parameters: nil, parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func books(_ authorId: String, success: (([Book]) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode(Books.self, from: data).results
            } catch {
                return [Book]()
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! [Book])
            } else {
                if let failure = failure {
                    failure(NSError(domain: TVTime, code: 99, userInfo: [NSLocalizedDescriptionKey : "noResultsFound"]))
                }
            }
        }
        
        performGetRequest(product: .lazyLibrarian, pathDictionary: ServerPaths, key: ServiceKeys.getBooksKey, parameters: [authorId], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func addAuthor(_ id: String, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (string: String) -> Any? in
            return string
        }
        
        let successBlock = { (results: Any?) -> Void in
            
            guard let results = results as? String else {
                if let failure = failure {
                    failure(NSError(domain: TVTime, code: 99, userInfo: [NSLocalizedDescriptionKey : "noAddAuthor"]))
                }
                return
            }
            
            if results.hasSuffix("Author update complete") {
                if let success = success {
                    success(true)
                }
            } else {
                if let success = success {
                    success(false)
                }
            }
        }
        
        let _ = performGetRequest(product: .lazyLibrarian, pathDictionary: ServerPaths, key: ServiceKeys.addAuthorKey, parameters: [id], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func refreshAuthor(_ name: String, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (string: String) -> Any? in
            return string == "OK"
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Bool)
            } else {
                if let failure = failure {
                    failure(NSError(domain: TVTime, code: 99, userInfo: [NSLocalizedDescriptionKey : "noQueueBook"]))
                }
            }
        }
        
        let _ = performGetRequest(product: .lazyLibrarian, pathDictionary: ServerPaths, key: ServiceKeys.refreshAuthorKey, parameters: [name], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func removeAuthor(_ id: String, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (string: String) -> Any? in
            return string == "OK"
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Bool)
            } else {
                if let failure = failure {
                    failure(NSError(domain: TVTime, code: 99, userInfo: [NSLocalizedDescriptionKey : "noRemoveAuthor"]))
                }
            }
        }
        
        let _ = performGetRequest(product: .lazyLibrarian, pathDictionary: ServerPaths, key: ServiceKeys.delAuthorKey, parameters: [id], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func removeBook(_ id: String, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(Bool.self, from: data)
            } catch {
                return false
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Bool)
            } else {
                if let failure = failure {
                    failure(NSError(domain: TVTime, code: 99, userInfo: [NSLocalizedDescriptionKey : "noRemoveAuthor"]))
                }
            }
        }
        
        performGetRequest(product: .lazyLibrarian, pathDictionary: ServerPaths, key: ServiceKeys.delBookKey, parameters: [id], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func queueBook(_ id: String, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (string: String) -> Any? in
            return string == "OK"
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Bool)
            } else {
                if let failure = failure {
                    failure(NSError(domain: TVTime, code: 99, userInfo: [NSLocalizedDescriptionKey : "noQueueBook"]))
                }
            }
        }
        
        let _ = performGetRequest(product: .lazyLibrarian, pathDictionary: ServerPaths, key: ServiceKeys.addBookKey, parameters: [id], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    
    public static func findAuthor(_ searchText: String, success: (([LLSearchResult]) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode([LLSearchResult].self, from: data)
            } catch {
                return [LLSearchResult]()
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! [LLSearchResult])
            } else {
                if let failure = failure {
                    failure(NSError(domain: TVTime, code: 99, userInfo: [NSLocalizedDescriptionKey : "noResultsFound"]))
                }
            }
        }
        
        performGetRequest(product: .lazyLibrarian, pathDictionary: ServerPaths, key: ServiceKeys.findAuthorKey, parameters: [searchText], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func findBook(_ searchText: String, success: (([LLSearchResult]) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode([LLSearchResult].self, from: data)
            } catch {
                return [LLSearchResult]()
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! [LLSearchResult])
            } else {
                if let failure = failure {
                    failure(NSError(domain: TVTime, code: 99, userInfo: [NSLocalizedDescriptionKey : "noResultsFound"]))
                }
            }
        }
        
        performGetRequest(product: .lazyLibrarian, pathDictionary: ServerPaths, key: ServiceKeys.findBookKey, parameters: [searchText], parse: parseBlock, success: successBlock, failure: failure)
    }
}
