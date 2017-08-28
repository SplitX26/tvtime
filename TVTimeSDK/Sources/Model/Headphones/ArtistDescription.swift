/******************************************************************************
 *
 * ArtistDescription
 *
 ******************************************************************************/

import Foundation

public struct ArtistDescription: Decodable {
    enum CodingKeys : String, CodingKey {
        case lastUpdated = "LastUpdated"
        case summary = "Summary"
        case content = "Content"
        case releaseId = "ReleaseID"
        case artistID = "ArtistID"
        case releaseGroupID = "ReleaseGroupID"
    }
    
    public let lastUpdated: String
    public let summary: String
    public let content: String
    public let releaseId: String?
    public let artistId: String
    public let releaseGroupId: String?
}

extension ArtistDescription {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        lastUpdated = try container.decode(String.self, forKey: .lastUpdated)
        summary = try container.decode(String.self, forKey: .summary)
        content = try container.decode(String.self, forKey: .content)
        releaseId = try container.decodeIfPresent(String.self, forKey: .releaseId)
        artistId = try container.decode(String.self, forKey: .artistID)
        releaseGroupId = try container.decodeIfPresent(String.self, forKey: .releaseGroupID)
    }
}
