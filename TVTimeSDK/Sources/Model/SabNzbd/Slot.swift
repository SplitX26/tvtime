/******************************************************************************
 *
 * Slot
 *
 ******************************************************************************/

import Foundation

public struct Slot : Decodable {
    
    public let status: String
    public let filename: String
    public let percentage: String
    public let nzo_id: String
    public let mb: String
    public let mbleft: String
}

