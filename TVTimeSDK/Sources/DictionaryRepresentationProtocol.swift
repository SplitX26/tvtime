/******************************************************************************
 *
 * DictionaryRepresentationProtocol
 *
 ******************************************************************************/

import Foundation

public typealias JSONDict = [String : Any]

protocol DictionaryRepresentationProtocol {
    func toDictionary() -> JSONDict
}
