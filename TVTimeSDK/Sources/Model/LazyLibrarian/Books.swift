/******************************************************************************
 *
 * Book
 *
 ******************************************************************************/

import Foundation

public struct Books: Decodable {
    
    fileprivate enum CodingKeys : String, CodingKey {
        case results = "books"
    }
    
    let results: [Book]
}
