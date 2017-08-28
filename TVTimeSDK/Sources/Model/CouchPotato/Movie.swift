/******************************************************************************
 *
 * Movie
 *
 ******************************************************************************/

import Foundation

public struct Movie: Decodable, Equatable {
    
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
        case release_date
    }
    
    enum ImagesCodingKeys : String, CodingKey {
        case poster
        case backdrop
    }
    
    public let status: Status
    public let title: String
    public let year: Int
    public let posters: [String]?
    public let backdrops: [String]?
    public let id: String
    public var profile: MovieProfile?
    public let releases: [MovieRelease]?
    public let releaseDate: MovieReleaseDate?
    public let isValid: Bool
}

public func == (lhs: Movie, rhs: Movie) -> Bool {
    return lhs.id == rhs.id
}

extension Movie {
    
    public init(movie: Movie, profile: MovieProfile) {
        
        status = movie.status
        self.profile = profile
        title = movie.title
        id = movie.id
        year = movie.year
        posters = movie.posters
        backdrops = movie.backdrops
        releases = movie.releases
        releaseDate = movie.releaseDate
        isValid = movie.isValid
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let status = try container.decode(Status.self, forKey: .status)
            let profileId = try container.decode(String.self, forKey: .profileId)
            let profile = MoviesManager.movieProfile(profileId)
            let title = try container.decode(String.self, forKey: .title)
            let id = try container.decode(String.self, forKey: .id)
            let releases = try container.decodeIfPresent([MovieRelease].self, forKey: .releases)
            
            let info = try container.nestedContainer(keyedBy: InfoCodingKeys.self, forKey: .info)
            let year = try info.decode(Int.self, forKey: .year)
            let releaseDate = try info.decodeIfPresent(MovieReleaseDate.self, forKey: .release_date)
            
            let imagesContainer = try info.nestedContainer(keyedBy: ImagesCodingKeys.self, forKey: .images)
            let posters = try imagesContainer.decodeIfPresent([String].self, forKey: .poster)
            let backdrops = try imagesContainer.decodeIfPresent([String].self, forKey: .backdrop)
            
            self = Movie(status: status, title: title, year: year, posters: posters, backdrops: backdrops, id: id, profile: profile, releases: releases, releaseDate: releaseDate, isValid: true)
        } catch {
            self = Movie(status: .done, title: "", year: Int.min, posters: nil, backdrops: nil, id: "", profile: nil, releases: nil, releaseDate: nil, isValid: false)
        }
    }
    
    public func imageUrl(_ type: ImageType) -> URL? {
        
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
