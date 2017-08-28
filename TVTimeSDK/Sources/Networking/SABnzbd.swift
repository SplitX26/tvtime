/******************************************************************************
 *
 * SABnzbd
 *
 ******************************************************************************/

import Foundation

public final class SABnzbd: Networking {
    
    private struct ServiceKeys {
        static let queueKey = "queue"
        static let pauseKey = "pause"
        static let resumeKey = "resume"
        static let deleteKey = "delete"
        static let moveKey = "move"
    }
    
    private static let ServerPaths = [
        ServiceKeys.queueKey: "queue",
        ServiceKeys.pauseKey: "queue&name=pause&value=%@",
        ServiceKeys.resumeKey: "queue&name=resume&value=%@",
        ServiceKeys.deleteKey: "queue&name=delete&value=%@",
        ServiceKeys.moveKey: "switch&value=%@&value2=%@"
    ]
    
    public static func queue(_ success: ((Queue) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode(SABQueue.self, from: data).queue
            } catch (let error) {
                return error
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            
            if let results = results as? Queue {
                if let success = success {
                    success(results)
                }
            } else {
                if let failure = failure {
                    failure(results as! Error)
                }
            }
        }
        
        performGetRequest(product: .sabnzbd, pathDictionary: ServerPaths, key: ServiceKeys.queueKey, parameters: nil, parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func pause(_ id: String, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode(ResponseStatus.self, from: data).status
            } catch {
                return false
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Bool)
            } else {
                if let failure = failure {
                    failure(NSError(domain: TVTime, code: 99, userInfo: [NSLocalizedDescriptionKey : "noResultsFound"]))
                }
            }
        }
        
        performGetRequest(product: .sabnzbd, pathDictionary: ServerPaths, key: ServiceKeys.pauseKey, parameters: [id], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func resume(_ id: String, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode(ResponseStatus.self, from: data).status
            } catch {
                return false
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Bool)
            } else {
                if let failure = failure {
                    failure(NSError(domain: TVTime, code: 99, userInfo: [NSLocalizedDescriptionKey : "noResultsFound"]))
                }
            }
        }
        
        performGetRequest(product: .sabnzbd, pathDictionary: ServerPaths, key: ServiceKeys.resumeKey, parameters: [id], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func delete(_ id: String, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode(ResponseStatus.self, from: data).status
            } catch {
                return false
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Bool)
            } else {
                if let failure = failure {
                    failure(NSError(domain: TVTime, code: 99, userInfo: [NSLocalizedDescriptionKey : "noResultsFound"]))
                }
            }
        }
        
        performGetRequest(product: .sabnzbd, pathDictionary: ServerPaths, key: ServiceKeys.deleteKey, parameters: [id], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func move(_ id: String, position: Int, success: ((MoveResult) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (data: Data) -> Any? in
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode(MoveResponse.self, from: data).result
            } catch {
                return error
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let results = results as? MoveResult {
                if let success = success {
                    success(results)
                }
            } else {
                if let failure = failure {
                    failure(results as! Error)
                }
            }
        }
        
        performGetRequest(product: .sabnzbd, pathDictionary: ServerPaths, key: ServiceKeys.moveKey, parameters: [id, String(position)], parse: parseBlock, success: successBlock, failure: failure)
    }
}
