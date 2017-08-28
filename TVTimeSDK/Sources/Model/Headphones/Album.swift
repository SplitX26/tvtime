/******************************************************************************
 *
 * Album
 *
 ******************************************************************************/

import Foundation

public struct Album: Decodable {
    
    fileprivate enum CodingKeys : String, CodingKey {
        case status = "Status"
        case albumASIN = "AlbumASIN"
        case dateAdded = "DateAdded"
        case title = "AlbumTitle"
        case releaseDate = "ReleaseDate"
        case albumId = "AlbumID"
        case releaseId = "ReleaseID"
        case type = "Type"
        case thumbURL = "ThumbURL"
        case artworkURL = "ArtworkURL"
    }
    
    public let status: String
    public let albumASIN: String?
    public let dateAdded: String?
    public let title: String
    public let releaseDate: String?
    public let albumId: String
    public let type: String
    public let releaseId: String
    public let thumbURL: URL?
    public let artworkURL: URL?
}


extension Album {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        status = try container.decode(String.self, forKey: .status)
        albumASIN = try container.decodeIfPresent(String.self, forKey: .albumASIN)
        dateAdded = try container.decodeIfPresent(String.self, forKey: .dateAdded)
        title = try container.decode(String.self, forKey: .title)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        albumId = try container.decode(String.self, forKey: .albumId)
        type = try container.decode(String.self, forKey: .type)
        releaseId = try container.decode(String.self, forKey: .releaseId)
        
        let thumbString = try container.decodeIfPresent(String.self, forKey: .thumbURL)
        if let thumbString = thumbString {
            thumbURL = URL(string: thumbString)
        } else {
            thumbURL = nil
        }
        
        let artworkString = try container.decodeIfPresent(String.self, forKey: .artworkURL)
        if let artworkString = artworkString {
            artworkURL = URL(string: artworkString)
        } else {
            artworkURL = nil
        }
    }
}
