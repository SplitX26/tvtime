/******************************************************************************
 *
 * Queue
 *
 ******************************************************************************/

import Foundation

public struct Queue : Decodable {
    
    public let status: String
    public let speed: String
    public let slots: [Slot]
}


