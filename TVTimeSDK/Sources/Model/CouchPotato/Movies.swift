/******************************************************************************
 *
 * Movies
 *
 ******************************************************************************/

public struct Movies: Decodable {

    enum CodingKeys : String, CodingKey {
        case results = "movies"
    }
    
    public let results: [Movie]?
}
