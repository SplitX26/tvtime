/******************************************************************************
 *
 * MovieReleaseDate
 *
 ******************************************************************************/

import Foundation

public struct MovieReleaseDate: Decodable {
    
    public let dvd: TimeInterval
    public let expires: TimeInterval
    public let theater: TimeInterval
    public let bluray: Bool
}

extension MovieReleaseDate {
    
    public func dvdReleaseDate() -> Date {
        return Date(timeIntervalSince1970: dvd)
    }
}
