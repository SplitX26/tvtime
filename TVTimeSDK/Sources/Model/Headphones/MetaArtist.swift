/******************************************************************************
 *
 * MetaArtist
 *
 ******************************************************************************/

import Foundation

public struct MetaArtist: Decodable {
    
    fileprivate enum CodingKeys : String, CodingKey {
        case artists = "artist"
        case description
        case albums
    }
    
    public let artists: [Artist]
    public let description: [ArtistDescription]
    public let albums: [Album]
}
