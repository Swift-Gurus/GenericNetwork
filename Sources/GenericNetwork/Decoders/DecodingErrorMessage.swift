import Foundation

struct DecodingErrorStrings {
    static let base = "JSONDecoder: "
    static func missingKey(_ key: String) -> String {
        base + "Missing Required Key: \(key)"
    }
    
    static func missingValue(_ keys: [String]) -> String {
        base + "Missing Required Values for Keys: \(keys.joined(separator: "; /n"))"
    }
    
    static func missingType(_ keys: [String], expected: Any.Type) -> String {
        base + "Type Mismatch Values For Keys: \(keys.joined(separator: "; /n")). Expected: \(expected)"
    }
}

public struct DecodingErrorMessage: Error, CustomDebugStringConvertible {
    public var debugDescription: String {
        switch original {
        case .typeMismatch(let type, let context):
            return  DecodingErrorStrings.missingType(context.codingPath.map({ $0.stringValue }),
                                                     expected: type)
        case .valueNotFound(_, let context):
            return DecodingErrorStrings.missingValue(context.codingPath.map({ $0.stringValue }))
        case .keyNotFound(let key, _):
            return DecodingErrorStrings.missingKey(key.stringValue)
        case .dataCorrupted(_):
            return "Fine"
        @unknown default:
            return "Fine"
        }
    }
    
    let original: DecodingError
    
    
    public var errorDescription: String? {
       return debugDescription
    }
    
    init(original: Error) throws {
        guard let error = original as? DecodingError else {
            throw original
        }
        self.original = error
    }
}


public extension Error {
    var decodingErrorOrSelf: Error {
        get throws { 
            try DecodingErrorMessage(original: self)
        }
    }
}

