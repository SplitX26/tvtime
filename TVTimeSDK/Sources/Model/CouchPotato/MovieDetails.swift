/******************************************************************************
 *
 * MovieDetails
 *
 ******************************************************************************/

import Foundation

public struct MovieDetails: Decodable, Equatable {

    public enum Status: String, Codable {
        case active
        case done
        case search
    }
    
    public enum ImageType: String, Codable {
        case poster
        case backdrop
    }
    
    enum CodingKeys : String, CodingKey {
        case media
        case success
    }
    
    enum MediaCodingKeys : String, CodingKey {
        case status
        case info
        case profileId = "profile_id"
        case title
        case id = "_id"
        case releases
    }
    
    enum InfoCodingKeys : String, CodingKey {
        case plot
        case tagline
        case images
        case year
        case imdb
    }
    
    enum ImagesCodingKeys : String, CodingKey {
        case poster
        case backdrop
    }
    
    public let success: Bool
    public let status: Status
    public let plot: String
    public let title: String
    public let year: Int
    public let tagline: String?
    public let posters: [String]?
    public let backdrops: [String]?
    public let imdb: String?
    public let id: String?
    public let profile: MovieProfile?
    public let releases: [MovieRelease]?

}

public func == (lhs: MovieDetails, rhs: MovieDetails) -> Bool {
    return lhs.id == rhs.id
}

extension MovieDetails {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let media = try container.nestedContainer(keyedBy: MediaCodingKeys.self, forKey: .media)
        let info = try media.nestedContainer(keyedBy: InfoCodingKeys.self, forKey: .info)
        let imagesContainer = try info.nestedContainer(keyedBy: ImagesCodingKeys.self, forKey: .images)
        
        success = try container.decode(Bool.self, forKey: .success)
        status = try media.decode(Status.self, forKey: .status)
        let profileId = try media.decode(String.self, forKey: .profileId)
        profile = MoviesManager.movieProfile(profileId)
        title = try media.decode(String.self, forKey: .title)
        id = try media.decode(String.self, forKey: .id)
        
        plot = try info.decode(String.self, forKey: .plot)
        tagline = try info.decode(String.self, forKey: .tagline)
        year = try info.decode(Int.self, forKey: .year)
        imdb = try info.decode(String.self, forKey: .imdb)
        posters = try imagesContainer.decodeIfPresent([String].self, forKey: .poster)
        backdrops = try imagesContainer.decodeIfPresent([String].self, forKey: .backdrop)
        releases = try media.decodeIfPresent([MovieRelease].self, forKey: .releases)
    }
    
    func imageUrl(_ type: ImagesCodingKeys) -> URL? {
        
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
