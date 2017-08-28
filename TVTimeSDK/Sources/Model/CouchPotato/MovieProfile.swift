/******************************************************************************
 *
 * MovieProfile
 *
 ******************************************************************************/

import Foundation

public struct MovieProfile: Decodable {
    
    enum CodingKeys : String, CodingKey {
        case id = "_id"
        case title = "label"
    }
    
    public let id: String
    public let title: String
}

extension MovieProfile {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
    }
}
