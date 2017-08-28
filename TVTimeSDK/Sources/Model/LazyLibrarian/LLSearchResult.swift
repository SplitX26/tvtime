/******************************************************************************
 *
 * LLSearchResult
 *
 ******************************************************************************/

import Foundation

public struct LLSearchResult: Decodable {
    
    public let booksub: String
    public let num_reviews: Double
    public let bookdate: String
    public let book_fuzz: Int
    public let bookrate: Double
    public let bookid: String
    public let isbn_fuzz: Int
    public let bookdesc: String
    public let bookname: String
    public let booklink: String
    public let bookpages: String
    public let authorid: String
    public let booklang: String
    public let author_fuzz: Int
    public let authorname: String
    public let bookisbn: String
    public let bookimg: String
    public let highest_fuzz: Int
    public let bookgenre: String
    public let bookpub: String
}
