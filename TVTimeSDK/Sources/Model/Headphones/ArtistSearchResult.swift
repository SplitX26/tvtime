/******************************************************************************
 *
 * ArtistSearchResult
 *
 ******************************************************************************/

import Foundation

public struct ArtistSearchResult: Decodable {
    
    public let url: String
    public let score: Int
    public let name: String
    public let uniquename: String
    public let id: String
}

