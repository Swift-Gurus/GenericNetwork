import Foundation

public extension JSONDecoder {
    func decode<T>(from data: Data) throws -> T where T : Decodable {
        do {
           return try decode(T.self, from: data)
        } catch {
           throw try DecodingErrorMessage(original: error)
        }
        
    }
}

