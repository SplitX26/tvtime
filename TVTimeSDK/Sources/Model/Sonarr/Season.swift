/******************************************************************************
 *
 * Season
 *
 ******************************************************************************/

import Foundation

public struct Season: Codable, Equatable {
    
    fileprivate enum CodingKeys : String, CodingKey {
        case seasonNumber
        case monitored
        case statistics
    }
    
    public let seasonNumber: Int
    public let monitored: Bool
    public let statistics: Statistics?
    
    public init(seasonNumber: Int, monitored: Bool, statistics: Statistics?) {
        self.seasonNumber = seasonNumber
        self.monitored = monitored
        self.statistics = statistics
    }
}

public func == (lhs: Season, rhs: Season) -> Bool {
    return lhs.seasonNumber == rhs.seasonNumber
}

public extension Season {
    
    public init(season: Season) {
        monitored = season.monitored
        seasonNumber = season.seasonNumber
        statistics = season.statistics
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        seasonNumber = try container.decode(Int.self, forKey: .seasonNumber)
        monitored = try container.decode(Bool.self, forKey: .monitored)
        statistics = try container.decodeIfPresent(Statistics.self, forKey: .statistics)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(seasonNumber, forKey: .seasonNumber)
        try container.encode(monitored, forKey: .monitored)
        try container.encode(statistics, forKey: .statistics)
    }
}


