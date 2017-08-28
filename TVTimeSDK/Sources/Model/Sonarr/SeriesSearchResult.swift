/******************************************************************************
 *
 * SeriesSearchResult
 *
 ******************************************************************************/

import Foundation
import DateHelper

public struct SeriesSearchResult: Codable {
    
    fileprivate enum CodingKeys : String, CodingKey {
        case overview
        case title
        case firstAired
        case images
        case titleSlug
        case path
        case qualityProfileId
        case seasons
        case tvdbId
        case rootFolderPath
        case monitored
        case addOptions
    }
    
    public let overview: String?
    public let title: String
    public let firstAired: Date?
    public var qualityProfileId: Int
    public let titleSlug: String
    public let path: String?
    public let images: [SeriesImage]?
    public let seasons: [Season]?
    public let tvdbId: Int
    public var rootFolderPath: String?
    public var monitored: Bool?
    public var addOptions: [String : Bool]?
    public let isValid: Bool
}

extension SeriesSearchResult {
    
    init(with searchResult: SeriesSearchResult, rootFolderPath: String) {
        
        overview = searchResult.overview
        title = searchResult.title
        firstAired = searchResult.firstAired
        qualityProfileId = searchResult.qualityProfileId
        titleSlug = searchResult.titleSlug
        path = searchResult.path
        images = searchResult.images
        seasons = searchResult.seasons
        tvdbId = searchResult.tvdbId
        self.rootFolderPath = rootFolderPath
        
        monitored = searchResult.monitored
        addOptions = searchResult.addOptions
        isValid = searchResult.isValid
    }
    
    public init(from decoder: Decoder) throws {
        
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let overview = try container.decodeIfPresent(String.self, forKey: .overview)
            let title = try container.decode(String.self, forKey: .title)
            
            var firstAired: Date?
            
            if let dateString = try container.decodeIfPresent(String.self, forKey: .firstAired) {
                firstAired = Date(fromString: dateString, format: .custom(Constants.SonarrDateFormatString))
            } else {
                firstAired = nil
            }
            
            let qualityProfileId = try container.decode(Int.self, forKey: .qualityProfileId)
            let titleSlug = try container.decode(String.self, forKey: .titleSlug)
            let path = try container.decodeIfPresent(String.self, forKey: .path)
            let images = try container.decodeIfPresent([SeriesImage].self, forKey: .images)
            let seasons = try container.decodeIfPresent([Season].self, forKey: .seasons)
            let tvdbId = try container.decode(Int.self, forKey: .tvdbId)
            
            let monitored = true
            let addOptions = ["ignoreEpisodesWithFiles" : true, "ignoreEpisodesWithoutFiles" : true]
            
            self = SeriesSearchResult(overview: overview, title: title, firstAired: firstAired, qualityProfileId: qualityProfileId, titleSlug: titleSlug, path: path, images: images, seasons: seasons, tvdbId: tvdbId, rootFolderPath: rootFolderPath, monitored: monitored, addOptions: addOptions, isValid : true)
        } catch {
            self = SeriesSearchResult(overview: nil, title: "", firstAired: nil, qualityProfileId: Int.min, titleSlug: "", path: nil, images: nil, seasons: nil, tvdbId: Int.min, rootFolderPath: nil, monitored: nil, addOptions: nil, isValid: false)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tvdbId, forKey: .tvdbId)
        try container.encode(title, forKey: .title)
        try container.encode(qualityProfileId, forKey: .qualityProfileId)
        try container.encode(titleSlug, forKey: .titleSlug)
        try container.encodeIfPresent(images, forKey: .images)
        try container.encodeIfPresent(seasons, forKey: .seasons)
        try container.encodeIfPresent(rootFolderPath, forKey: .rootFolderPath)
        try container.encodeIfPresent(monitored, forKey: CodingKeys.monitored)
        try container.encodeIfPresent(addOptions, forKey: CodingKeys.addOptions)
    }
}
