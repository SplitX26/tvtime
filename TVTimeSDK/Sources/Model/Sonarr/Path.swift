/******************************************************************************
 *
 * Path
 *
 ******************************************************************************/

import Foundation

public struct Path: Decodable {

    public let path: String
    public let freeSpace: Int64?
    public let unmappedFolders: [[String : String]]?
    public let id: Int
}

