/******************************************************************************
 *
 * Author.swift
 *
 ******************************************************************************/

import Foundation

public struct Author: Codable {
    
    fileprivate enum CodingKeys : String, CodingKey {
        case status = "Status"
        case haveBooks = "HaveBooks"
        case dateAdded = "DateAdded"
        case authorDeath = "AuthorDeath"
        case authorBorn = "AuthorBorn"
        case authorLink = "AuthorLink"
        case lastBookImg = "LastBookImg"
        case manual = "Manual"
        case name = "AuthorName"
        case id = "AuthorID"
        case image = "AuthorImg"
        case lastBook = "LastBook"
        case unignoredBooks = "UnignoredBooks"
        case lastDate = "LastDate"
        case totalBooks = "TotalBooks"
        case lastLink = "LastLink"
    }
    
    public let status: String
    public let haveBooks: Int
    public let dateAdded: String
    public let name: String
    public let id: String
    public let unignoredBooks: Int
    public let totalBooks: Int
    
    public let lastDate: String?
    public let lastBook: String?
    public let lastLink: String?
    public let authorDeath: String?
    public let authorBorn: String?
    public let authorLink: String?
    public let lastBookImg: String?
    public let manual: String?
    public let image: String?
}

extension Author {
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        status = try container.decode(String.self, forKey: .status)
        dateAdded = try container.decode(String.self, forKey: .dateAdded)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        lastDate = try container.decodeIfPresent(String.self, forKey: .lastDate)
        lastBook = try container.decodeIfPresent(String.self, forKey: .lastBook)
        manual = try container.decodeIfPresent(String.self, forKey: .manual)
        authorDeath = try container.decodeIfPresent(String.self, forKey: .authorDeath)
        authorBorn = try container.decodeIfPresent(String.self, forKey: .authorBorn)
        authorLink = try container.decodeIfPresent(String.self, forKey: .authorLink)
        lastBookImg = try container.decodeIfPresent(String.self, forKey: .lastBookImg)
        unignoredBooks = try container.decodeIfPresent(Int.self, forKey: .unignoredBooks) ?? 0
        haveBooks = try container.decodeIfPresent(Int.self, forKey: .haveBooks) ?? 0
        totalBooks = try container.decodeIfPresent(Int.self, forKey: .totalBooks) ?? 0
        lastLink = try container.decodeIfPresent(String.self, forKey: .lastLink)
        image = try container.decodeIfPresent(String.self, forKey: .image)
    }
}
