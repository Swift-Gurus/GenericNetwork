import Foundation
@testable import GenericNetwork

extension Error {
    func getNetworkError<T: Decodable>() -> GenericNetworkError<T>? {
        self as? GenericNetworkError<T>
    }
}
