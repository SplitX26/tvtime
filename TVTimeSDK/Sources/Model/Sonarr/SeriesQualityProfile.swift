/******************************************************************************
 *
 * SereisQualityProfile
 *
 ******************************************************************************/

import Foundation

public struct SeriesQualityProfile: Equatable, Decodable {
    
    public let name: String
    public let cutoff: SeriesQualityProfileType
    public var items: [SeriesQualityProfileItem]?
    public let language: String
    public let id: Int    
}

public func == (lhs: SeriesQualityProfile, rhs: SeriesQualityProfile) -> Bool {
    return lhs.id == rhs.id
}
