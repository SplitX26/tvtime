/******************************************************************************
 *
 * Episode
 *
 ******************************************************************************/

import Foundation

public struct Episode: Decodable {
    
    private let seriesId: Int
    private let episodeFileId: Int
    private let episodeNumber: Int
    private let airDateUtc: String?
    
    public let seasonNumber: Int
    public let title: String
    public let airDate: String?
    public let overview: String?
    public let hasFile: Bool
    public let id: Int
}
