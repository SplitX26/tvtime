/******************************************************************************
 *
 * Artist
 *
 ******************************************************************************/

import Foundation

public struct Artist: Decodable {
    
    enum CodingKeys : String, CodingKey {
        case thumbUrl = "ThumbURL"
        case artworkUrl = "ArtworkURL"
        case name = "ArtistName"
        case id = "ArtistID"
    }
    
    public let name: String
    public let id: String
    public let thumbUrl: URL?
    public let artworkUrl: URL?
}

extension Artist {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(String.self, forKey: .id)
        
        let artworkString = try container.decodeIfPresent(String.self, forKey: .artworkUrl)
        if let artworkString = artworkString {
            artworkUrl = URL(string: artworkString)
        } else {
            artworkUrl = nil
        }
        
        let thumbString = try container.decodeIfPresent(String.self, forKey: .thumbUrl)
        if let thumbString = thumbString {
            thumbUrl = URL(string: thumbString)
        } else {
            thumbUrl = nil
        }
    }
}


