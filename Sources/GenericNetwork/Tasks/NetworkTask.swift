import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

protocol NetworkTask {
    associatedtype Body
    func perform(using: URLRequestConvertible) async throws -> NetworkResponse<Body>
}
