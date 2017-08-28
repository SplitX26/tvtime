/******************************************************************************
 *
 * MovieRelease
 *
 ******************************************************************************/

import Foundation

public struct MovieRelease: Decodable {
    
    public enum Status: String, Codable {
        case available
        case ignored
        case snatched
        case failed
        case missing
        case done
    }
    
    enum CodingKeys : String, CodingKey {
        case status
        case info
        case id = "_id"
        case quality
    }
    
    enum InfoCodingKeys : String, CodingKey {
        case age
        case score
        case name
        case size
    }
    
    public let status: Status
    public let age: Int
    public let score: Int
    public let size: Int
    public let id: String
    public let quality: String
    public let name: String
}

extension MovieRelease {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(Status.self, forKey: .status)
        id = try container.decode(String.self, forKey: .id)
        quality = try container.decode(String.self, forKey: .quality)
        
        if status == .done {
            age = 0
            score = 0
            size = 0
            name = "N/A"
        } else {
            let info = try container.nestedContainer(keyedBy: InfoCodingKeys.self, forKey: .info)
            age = try info.decode(Int.self, forKey: .age)
            score = try info.decode(Int.self, forKey: .score)
            size = try info.decode(Int.self, forKey: .size)
            name = try info.decode(String.self, forKey: .name)
        }
    }
}
