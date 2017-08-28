/******************************************************************************
 *
 * Book
 *
 ******************************************************************************/

import Foundation

public struct Book: Codable {
    
    fileprivate enum CodingKeys : String, CodingKey {
        case status = "Status"
        case series = "BookSub"
        case description = "BookDesc"
        case image = "BookImg"
        case title = "BookName"
        case id = "BookID"
        case releaseDate = "BookDate"
        case link = "BookLink"
    }
    
    public let status: String
    public let series: String
    public let description: String?
    public let image: String
    public let title: String
    public let id: String
    public let releaseDate: String
    public let link: String
}


extension Book {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        status = try container.decode(String.self, forKey: .status)
        series = try container.decode(String.self, forKey: .series)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        image = try container.decode(String.self, forKey: .image)
        title = try container.decode(String.self, forKey: .title)
        id = try container.decode(String.self, forKey: .id)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        link = try container.decode(String.self, forKey: .link)
    }
}

