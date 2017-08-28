/******************************************************************************
 *
 * SeriesImage
 *
 ******************************************************************************/

import Foundation

public struct SeriesImage: Codable {
        
    public enum ImageType: String, Codable {
        case fanart
        case banner
        case poster
    }
    
    public let coverType: ImageType
    public let url: String
}
