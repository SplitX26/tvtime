/******************************************************************************
 *
 * URLRequest+Extensions
 *
 ******************************************************************************/

import Foundation

extension URLRequest {

    mutating func setPostHeaders() {
        setValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
        setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        setValue("en-US,en;q=0.8", forHTTPHeaderField: "Accept-Language")
    }

    mutating func addHeaders(_ headers: [String: String]) {
        for (key, value) in headers {
            setValue(value, forHTTPHeaderField: key)
        }
    }
    
    func authorizationHeader(user: String, password: String) -> (key: String, value: String)? {
        
        guard let data = "\(user):\(password)".data(using: .utf8) else { return nil }
        
        let credential = data.base64EncodedString(options: [])
        
        return (key: "Authorization", value: "Basic \(credential)")
    }
}
