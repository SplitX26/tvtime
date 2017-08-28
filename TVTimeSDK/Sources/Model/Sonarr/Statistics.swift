/******************************************************************************
 *
 * Statistics
 *
 ******************************************************************************/

import Foundation

public struct Statistics: Codable {
    
    public let episodeFileCount: Int
    public let episodeCount: Int
    public let totalEpisodeCount: Int
    public let sizeOnDisk: Int
    public let percentOfEpisodes: Int
    public let previousAiring: String?
}

