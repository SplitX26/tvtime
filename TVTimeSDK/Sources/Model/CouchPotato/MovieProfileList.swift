/******************************************************************************
 *
 * MovieProfile
 *
 ******************************************************************************/

import Foundation

public struct MovieProfileList: Decodable  {
    
    public let success: Bool
    public let list: [MovieProfile]
}
