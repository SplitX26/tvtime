/******************************************************************************
 *
 * SeriesQualityProfileItem
 *
 ******************************************************************************/

import Foundation

public struct SeriesQualityProfileItem: Decodable {

    public let quality: SeriesQualityProfileType
    public let allowed: Bool    
}
