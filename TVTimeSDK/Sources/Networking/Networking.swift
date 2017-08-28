/******************************************************************************
 *
 * Networking
 *
 ******************************************************************************/

import Foundation

public class Networking {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    public struct Headers {
        static let xApiKey = "X-Api-Key"
        static let authorization = "Authorization"
    }
    
    static let TVTime = "TVTimeSDK"
    
    #if os(iOS)
    private static let reachability = Reachability()
    public static var notReachableBlock: (() -> Void)?
    public static var reachableBlock: (() -> Void)?
    #endif
    
    static func performGetRequest(product: Product, pathDictionary: [String : String], key: String, parameters: [String]?, headers: [String: String]? = nil, requireToken: Bool = true, parse: @escaping (Data) -> Any?, success: ((Any?) -> Void)?, failure: ((Error) -> Void)?) {
        
        performRequest(product: product, pathDictionary: pathDictionary, method: .get, key: key, parameters: parameters, headers: headers, requireToken: requireToken, postBody: nil, parse: parse, success: success, failure: failure)
    }
    
    static func performGetRequest(product: Product, pathDictionary: [String : String], key: String, parameters: [String]?, headers: [String: String]? = nil, requireToken: Bool = true, parse: @escaping (String) -> Any?, success: ((Any?) -> Void)?, failure: ((Error) -> Void)?) -> Int? {
        
        return performRequest(product: product, pathDictionary: pathDictionary, method: .get, key: key, parameters: parameters, headers: headers, requireToken: requireToken, postBody: nil, parse: parse, success: success, failure: failure)
    }
    
    static func performPostRequest(product: Product, pathDictionary: [String : String], key: String, parameters: [String]?, postBody: Data?, parse: @escaping (Data) -> Any?, success: ((Any?) -> Void)?, failure: ((Error) -> Void)?) {
        
        performRequest(product: product, pathDictionary: pathDictionary, method: .post, key: key, parameters: parameters, postBody: postBody,
                       parse: parse, success: success, failure: failure)
    }
    
    static func performPutRequest(product: Product, pathDictionary: [String : String], key: String, parameters: [String]?, putBody: Data?, parse: @escaping (Data) -> Any?, success: ((Any?) -> Void)?, failure: ((Error) -> Void)?) {
        
        performRequest(product: product, pathDictionary: pathDictionary, method: .put, key: key, parameters: parameters, postBody: putBody,
                       parse: parse, success: success, failure: failure)
    }
    
    static func performDeleteRequest(product: Product, pathDictionary: [String : String], key: String, parameters: [String]?, postBody: Data? = nil, parse: @escaping (Data) -> Any?, success: ((Any?) -> Void)?, failure: ((Error) -> Void)?) {
        
        performRequest(product: product, pathDictionary: pathDictionary, method: .delete, key: key, parameters: parameters, postBody: postBody,
                       parse: parse, success: success, failure: failure)
    }
    
    static func performRequest(product: Product, pathDictionary: [String : String], method: HTTPMethod, key: String, parameters: [String]?, headers: [String: String]? = nil, requireToken: Bool = true, postBody: Data?, parse: @escaping (Data) -> Any?, success: ((Any?) -> Void)?, failure: ((Error) -> Void)?) {
        
        guard let url = getURLFor(product, pathDictonary: pathDictionary, key: key, parameters: parameters) else {
            if let failure = failure {
                failure(NSError(domain: TVTime, code: 99, userInfo: [NSLocalizedDescriptionKey : "Invalid URL or Settings"]))
            }
            return
        }
        
        debugLog(url.absoluteString)
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if product == .headphones || product == .lazyLibrarian {
            request.timeoutInterval = 180
        } else {
            request.timeoutInterval = 30
        }
        
        if method == .post || method == .put {
            
            request.setPostHeaders()
            
            if let postBody = postBody {
                
                request.httpBody = postBody
                
                do {
                    let value = try JSONSerialization.jsonObject(with: postBody, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    if JSONSerialization.isValidJSONObject(value) {
                        
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        
                        if let foo = String(data: data, encoding: .utf8) {
                            debugLog(foo)
                        }
                    }
                } catch (let error) {
                    print(error.localizedDescription)
                }
            }
        } else if method == .get {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        // Add optional headers
        if let headers = headers {
            request.addHeaders(headers)
        }
        
        addTrackingHeaders(product, request: &request)
        
        #if os(iOS)
            NetworkActivityIndicatorManager.incrementActivityCount()
        #endif
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            #if os(iOS)
                NetworkActivityIndicatorManager.decrementActivityCount()
            #endif
            if let error = error {
                if let failure = failure {
                    DispatchQueue.main.async {
                        failure(error)
                    }
                }
            } else if let data = data {
                let results = parse(data)
                
                if let success = success {
                    DispatchQueue.main.async {
                        success(results)
                    }
                }
            }
            }.resume()
    }
    
    static func performRequest(product: Product, pathDictionary: [String : String], method: HTTPMethod, key: String, parameters: [String]?, headers: [String: String]? = nil, requireToken: Bool = true, postBody: Data?, parse: @escaping (String) -> Any?, success: ((Any?) -> Void)?, failure: ((Error) -> Void)?) -> Int? {
        
        guard let url = getURLFor(product, pathDictonary: pathDictionary, key: key, parameters: parameters) else {
            if let failure = failure {
                failure(NSError(domain: TVTime, code: 99, userInfo: [NSLocalizedDescriptionKey : "Invalid Settings"]))
            }
            return nil
        }
        
        debugLog(url.absoluteString)
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if product == .headphones || product == .lazyLibrarian {
            request.timeoutInterval = 180
        } else {
            request.timeoutInterval = 10
        }
        
        if method == .get {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        // Add optional headers
        if let headers = headers {
            request.addHeaders(headers)
        }
        
        addTrackingHeaders(product, request: &request)
        
        #if os(iOS)
            NetworkActivityIndicatorManager.incrementActivityCount()
        #endif
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            #if os(iOS)
                NetworkActivityIndicatorManager.decrementActivityCount()
            #endif
            
            if let error = error {
                if let failure = failure {
                    DispatchQueue.main.async {
                        failure(error)
                    }
                }
            } else if let data = data, let value = String(data: data, encoding: .utf8) {
                let results = parse(value)
                
                if let success = success {
                    DispatchQueue.main.async {
                        success(results)
                    }
                }
            } else {
                if let failure = failure {
                    DispatchQueue.main.async {
                        failure(NSError(domain: TVTime, code: 99, userInfo: [NSLocalizedDescriptionKey : "noResultsFound"]))
                    }
                }
            }
        }
        task.resume()
        return task.taskIdentifier
    }
    
    #if os(iOS)
    public static func startWiFiDetection() {
        
        reachability?.whenReachable = { reachability in
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Constants.Notifications.ReachableViaWiFiNotification, object: nil)
                
                if let reachableBlock = reachableBlock {
                    reachableBlock()
                }
            }
        }
        
        reachability?.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                if let notReachableBlock = notReachableBlock {
                    notReachableBlock()
                }
            }
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            debugPrint("Unable to start notifier")
        }
    }
    
    public static func stopWiFiDetection() {
        reachability?.stopNotifier()
    }
    #endif
    
}
// MARK: - Helper methods
extension Networking {
    
    //MARK: Private Utility Methods
    
    static func getURLFor(_ product: Product, pathDictonary: [String : String], key: String, parameters: [String]?) -> URL? {
        
        guard let urlString = urlWithKey(product, pathDictonary: pathDictonary, key: key, parameters: parameters), let url = URL(string: urlString) else {
            return nil
        }
        
        return url
    }
    
    static func addTrackingHeaders(_ product: Product, request: inout URLRequest) {
        
        if let apiKeyHeader = getAPIKeyHeader(product) {
            request.addHeaders(apiKeyHeader)
        }
    }
    
    static func getAPIKeyHeader(_ product: Product) -> [String: String]? {
        
        var headers: [String: String]? = nil
        
        if product == .sonarr {
            if let defaults = Settings(.sonarr) {
                headers = [Headers.xApiKey: defaults.api]
            }
        } else {
            debugLog("x-api-key is not set")
        }
        
        return headers
    }
    
    static func pathAndQueryWithKey(_ key: String, pathDictonary: [String : String], parameters: [String]?) -> String? {
        
        var pathAndQuery: String?
        
        if let baseURLString = pathDictonary[key] {
            if let parameters = parameters {
                
                var tempString = baseURLString
                
                for param in parameters {
                    
                    if tempString.contains("%@") {
                        tempString = tempString.replacingCharacters(in: tempString.range(of: "%@")!, with: param)
                    } else {
                        tempString = String(format: "%@&%@", tempString, param)
                    }
                    
                }
                
                pathAndQuery = tempString
            }
            else {
                pathAndQuery = baseURLString
            }
        }
        
        return pathAndQuery
    }
    
    static func urlWithKey(_ product: Product, pathDictonary: [String : String], key: String, parameters: [String]? = nil) -> String? {
        
        let encodedParamters = parameters?.flatMap { $0.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) }
        
        guard let parameters = pathAndQueryWithKey(key, pathDictonary: pathDictonary, parameters: encodedParamters), let hostUrl = product.baseURL() else {
            return nil
        }
        
        return hostUrl + parameters
    }
}
