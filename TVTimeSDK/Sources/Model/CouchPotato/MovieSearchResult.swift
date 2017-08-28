/******************************************************************************
 *
 * MovieSearchResult
 *
 ******************************************************************************/

import Foundation

public struct MovieSearchResult: Decodable {
    
    enum CodingKeys : String, CodingKey {
        case plot
        case title = "original_title"
        case imdb
        case images
        case year
        case profileId = "profile_id"
    }
    
    public enum ImagesCodingKeys : String, CodingKey {
        case poster
        case backdrop
    }
    
    public let plot: String
    public let title: String
    public let year: Int
    public let imdb: String
    public let posters: [String]?
    public let backdrops: [String]?
    public var profileId: String?
}

extension MovieSearchResult {
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        plot = try container.decode(String.self, forKey: .plot)
        title = try container.decode(String.self, forKey: .title)
        imdb = try container.decode(String.self, forKey: .imdb)
        year = try container.decode(Int.self, forKey: .year)
        
        let imagesContainer = try container.nestedContainer(keyedBy: ImagesCodingKeys.self, forKey: .images)
        
        posters = try imagesContainer.decodeIfPresent([String].self, forKey: .poster)
        backdrops = try imagesContainer.decodeIfPresent([String].self, forKey: .backdrop)
        
        profileId = MoviesManager.profileId(for: "Best")
    }
    
    public func imageUrl(_ type: ImagesCodingKeys) -> URL? {
        
        var url: URL? = nil
        
        switch type {
        case .poster:
            if let poster = posters?.first {
                url = URL(string: poster)
            }
        case .backdrop:
            if let backdrop = backdrops?.first {
                url = URL(string: backdrop)
            }
        }
        
        return url
    }
}
