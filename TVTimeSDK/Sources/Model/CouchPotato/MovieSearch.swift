/******************************************************************************
 *
 * MovieSearch
 *
 ******************************************************************************/

import Foundation

public struct MovieSearch: Decodable {
    
    enum CodingKeys : String, CodingKey {
        case movies
        case success
    }
    
    public let movies: [MovieSearchResult]
    public let success: Bool
}
