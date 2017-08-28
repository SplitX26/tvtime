/******************************************************************************
 *
 * Series
 *
 ******************************************************************************/

import Foundation
import DateHelper

public struct Series: Codable, Equatable {
    
    public enum Monitor: String {
        case all = "All"
        case future = "Future"
        case missing = "Missing"
        
        public static let allValues = [all, future, missing]
        
        public func seasonsToMonitor() -> (monitored: Bool, addOptions: [String : Bool]) {
            
            var ignoreEpisodesWithFiles = true
            var ignoreEpisodesWithoutFiles = true
            
            switch self {
            case .all:
                ignoreEpisodesWithFiles = false
                ignoreEpisodesWithoutFiles = false
            case .future:
                ignoreEpisodesWithFiles = true
                ignoreEpisodesWithoutFiles = true
            case .missing:
                ignoreEpisodesWithFiles = true
                ignoreEpisodesWithoutFiles = false
            }
            
            return (true, ["ignoreEpisodesWithFiles" : ignoreEpisodesWithFiles, "ignoreEpisodesWithoutFiles" : ignoreEpisodesWithoutFiles])
        }
    }
    
    fileprivate enum CodingKeys : String, CodingKey {
        case status
        case title
        case overview
        case network
        case year
        case firstAired
        case qualityProfileId
        case tvdbId
        case images
        case titleSlug
        case seasons
        case path
        case alternateTitles
        case sortTitle
        case seasonCount
        case totalEpisodeCount
        case episodeCount
        case episodeFileCount
        case sizeOnDisk
        case previousAiring
        case nextAiring
        case airTime
        case monitored
        case profileId
        case seasonFolder
        case useSceneNumbering
        case tvRageId
        case tvMazeId
        case seriesType
        case cleanTitle
        case imdbId
        case genres
        case tags
        case ratings
        case added
        case runtime
        case id
    }
    
    public let title: String
    public let alternateTitles: [AlternateTitle]?
    public let sortTitle: String
    public let seasonCount: Int
    public let totalEpisodeCount: Int?
    public let episodeCount: Int?
    public let episodeFileCount: Int?
    public let sizeOnDisk: Int?
    public let status: String
    public let overview: String?
    public let nextAiring: String?
    public let previousAiring: String?
    public let network: String?
    public let airTime: String?
    public let images: [SeriesImage]?
    public let seasons: [Season]?
    public let year: Int
    public let path: String?
    public let profileId: Int
    public let seasonFolder: Bool
    public let monitored: Bool
    public let useSceneNumbering: Bool
    public let runtime: Int
    public let tvdbId: Int
    public let tvRageId: Int
    public let tvMazeId: Int
    public let firstAired: String?
    public let seriesType: String
    public let cleanTitle: String
    public let imdbId: String?
    public let titleSlug: String
    public let genres: [String]
    public let tags: [String]
    public let added: String
    public let ratings: Ratings?
    public let qualityProfileId: Int
    public let id: Int
    public let profile: SeriesQualityProfile?
    public let isValid: Bool
}

public func == (lhs: Series, rhs: Series) -> Bool {
    return lhs.tvdbId == rhs.tvdbId
}

extension Series {
    
    public init(series: Series, profile: SeriesQualityProfile) {
        
        self.profile = profile
        qualityProfileId = profile.id
        
        seasons = series.seasons
        title = series.title
        alternateTitles = series.alternateTitles
        sortTitle = series.sortTitle
        seasonCount = series.seasonCount
        totalEpisodeCount = series.totalEpisodeCount
        episodeCount = series.episodeCount
        episodeFileCount = series.episodeFileCount
        sizeOnDisk = series.sizeOnDisk
        status = series.status
        overview = series.overview
        nextAiring = series.nextAiring
        previousAiring = series.previousAiring
        network = series.network
        airTime = series.airTime
        images = series.images
        year = series.year
        path = series.path
        profileId = profile.id
        seasonFolder = series.seasonFolder
        monitored = series.monitored
        useSceneNumbering = series.useSceneNumbering
        runtime = series.runtime
        tvdbId = series.tvdbId
        tvRageId = series.tvRageId
        tvMazeId = series.tvMazeId
        firstAired = series.firstAired
        seriesType = series.seriesType
        cleanTitle = series.cleanTitle
        imdbId = series.imdbId
        titleSlug = series.titleSlug
        genres = series.genres
        tags = series.tags
        added = series.added
        ratings = series.ratings
        id = series.id
        isValid = series.isValid
    }
    
    public init(series: Series, updatedSeasons: [Season]) {
        
        var mutableSeasons = series.seasons?.flatMap({ Season(season: $0) }) ?? [Season]()
        
        updatedSeasons.forEach { (updatedSeason) in
            if let index = mutableSeasons.index(of: updatedSeason) {
                mutableSeasons[index] = updatedSeason
            }
        }
        
        seasons = mutableSeasons
        
        title = series.title
        alternateTitles = series.alternateTitles
        sortTitle = series.sortTitle
        seasonCount = series.seasonCount
        totalEpisodeCount = series.totalEpisodeCount
        episodeCount = series.episodeCount
        episodeFileCount = series.episodeFileCount
        sizeOnDisk = series.sizeOnDisk
        status = series.status
        overview = series.overview
        nextAiring = series.nextAiring
        previousAiring = series.previousAiring
        network = series.network
        airTime = series.airTime
        images = series.images
        year = series.year
        path = series.path
        profileId = series.profileId
        seasonFolder = series.seasonFolder
        monitored = series.monitored
        useSceneNumbering = series.useSceneNumbering
        runtime = series.runtime
        tvdbId = series.tvdbId
        tvRageId = series.tvRageId
        tvMazeId = series.tvMazeId
        firstAired = series.firstAired
        seriesType = series.seriesType
        cleanTitle = series.cleanTitle
        imdbId = series.imdbId
        titleSlug = series.titleSlug
        genres = series.genres
        tags = series.tags
        added = series.added
        ratings = series.ratings
        qualityProfileId = series.qualityProfileId
        id = series.id
        
        profile = series.profile
        isValid = series.isValid
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            let title = try container.decode(String.self, forKey: .title)
            let sortTitle = try container.decode(String.self, forKey: .sortTitle)
            let seasonCount = try container.decode(Int.self, forKey: .seasonCount)
            let status = try container.decode(String.self, forKey: .status)
            let year = try container.decode(Int.self, forKey: .year)
            let profileId = try container.decode(Int.self, forKey: .profileId)
            let seasonFolder = try container.decode(Bool.self, forKey: .seasonFolder)
            let monitored = try container.decode(Bool.self, forKey: .monitored)
            let useSceneNumbering = try container.decode(Bool.self, forKey: .useSceneNumbering)
            let runtime = try container.decode(Int.self, forKey: .runtime)
            let tvdbId = try container.decode(Int.self, forKey: .tvdbId)
            let tvRageId = try container.decode(Int.self, forKey: .tvRageId)
            let tvMazeId = try container.decode(Int.self, forKey: .tvMazeId)
            let seriesType = try container.decode(String.self, forKey: .seriesType)
            let cleanTitle = try container.decode(String.self, forKey: .cleanTitle)
            let titleSlug = try container.decode(String.self, forKey: .titleSlug)
            let genres = try container.decode([String].self, forKey: .genres)
            let tags = try container.decode([String].self, forKey: .tags)
            let added = try container.decode(String.self, forKey: .added)
            let ratings = try container.decode(Ratings.self, forKey: .ratings)
            let qualityProfileId = try container.decode(Int.self, forKey: .qualityProfileId)
            let id = try container.decode(Int.self, forKey: .id)
            
            let alternateTitles = try container.decodeIfPresent([AlternateTitle].self, forKey: .alternateTitles)
            let totalEpisodeCount = try container.decodeIfPresent(Int.self, forKey: .totalEpisodeCount)
            let episodeCount = try container.decodeIfPresent(Int.self, forKey: .episodeCount)
            let episodeFileCount = try container.decodeIfPresent(Int.self, forKey: .episodeFileCount)
            let sizeOnDisk = try container.decodeIfPresent(Int.self, forKey: .sizeOnDisk)
            let overview = try container.decodeIfPresent(String.self, forKey: .overview)
            let nextAiring = try container.decodeIfPresent(String.self, forKey: .nextAiring)
            let previousAiring = try container.decodeIfPresent(String.self, forKey: .previousAiring)
            let network = try container.decodeIfPresent(String.self, forKey: .network)
            let airTime = try container.decodeIfPresent(String.self, forKey: .airTime)
            let images = try container.decodeIfPresent([SeriesImage].self, forKey: .images)
            let seasons = try container.decodeIfPresent([Season].self, forKey: .seasons)?.filter({ $0.seasonNumber != 0 })
            let path = try container.decodeIfPresent(String.self, forKey: .path)
            let imdbId = try container.decodeIfPresent(String.self, forKey: .imdbId)
            let firstAired = try container.decodeIfPresent(String.self, forKey: .firstAired)
            
            let profile = SeriesManager.qualityProfile(qualityProfileId)

            self = Series(title: title, alternateTitles: alternateTitles, sortTitle: sortTitle, seasonCount: seasonCount, totalEpisodeCount: totalEpisodeCount, episodeCount: episodeCount, episodeFileCount: episodeFileCount, sizeOnDisk: sizeOnDisk, status: status, overview: overview, nextAiring: nextAiring, previousAiring: previousAiring, network: network, airTime: airTime, images: images, seasons: seasons, year: year, path: path, profileId: profileId, seasonFolder: seasonFolder, monitored: monitored, useSceneNumbering: useSceneNumbering, runtime: runtime, tvdbId: tvdbId, tvRageId: tvRageId, tvMazeId: tvMazeId, firstAired: firstAired, seriesType: seriesType, cleanTitle: cleanTitle, imdbId: imdbId, titleSlug: titleSlug, genres: genres, tags: tags, added: added, ratings: ratings, qualityProfileId: qualityProfileId, id: id, profile: profile, isValid: true)

            
        } catch {
            self = Series(title: "", alternateTitles: nil, sortTitle: "", seasonCount: Int.min, totalEpisodeCount: nil, episodeCount: nil, episodeFileCount: nil, sizeOnDisk: nil, status: "", overview: nil, nextAiring: nil, previousAiring: nil, network: nil, airTime: nil, images: nil, seasons: nil, year: Int.min, path: nil, profileId: Int.min, seasonFolder: false, monitored: false, useSceneNumbering: false, runtime: Int.min, tvdbId: Int.min, tvRageId: Int.min, tvMazeId: Int.min, firstAired: nil, seriesType: "", cleanTitle: "", imdbId: nil, titleSlug: "", genres: [], tags: [], added: "", ratings: nil, qualityProfileId: Int.min, id: Int.min, profile: nil, isValid: false)
        }
    }
    
    public func imageUrl(_ type: SeriesImage.ImageType) -> URL? {
        
        guard let images = images, let urlString = images.filter({ $0.coverType.rawValue == type.rawValue }).first?.url, let hostUrl = Product.baseURL(.sonarr)() else {
            return nil
        }
        
        return URL(string: hostUrl + urlString)
    }
    
    public func nextAirDate() -> String {
        
        let dateString = nextAiring ?? Date.distantFuture.toString(format: .custom(Constants.SonarrDateFormatString))
        
        guard let date = Date(fromString: dateString, format: .custom(Constants.SonarrDateFormatString)) else {
            return ""
        }
        
        if date.compare(.isToday) {
            return date.toString(format: .custom("h:mm a"), timeZone: .local)
        } else if date.compare(.isTomorrow) {
            return "Tomorrow"
        } else if date.compare(.isThisWeek) || date.compare(.isNextWeek) {
            return date.toString(style: .shortWeekday)
        } else if date.compare(.isThisYear) {
            
            let days = date.since(Date(), in: .day)
            
            switch days {
            case let x where x < 30:
                return String(format:"in %d days", x)
            case let x where x >= 30 && x <= 60:
                return "in a month"
            case let x where x >= 60 && x <= 90:
                return "in 2 months"
            case let x where x >= 90 && x <= 120:
                return "in 3 months"
            case let x where x >= 120 && x <= 150:
                return "in 4 months"
            default:
                return ""
            }
        } else if date == Date.distantFuture {
            return ""
        } else {
            return "Next Episode: \(date.toString(format: .custom("MMM dd yyyy, h:mm a"), timeZone: .local))"
        }
    }
}

