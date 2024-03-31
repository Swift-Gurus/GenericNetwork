import Foundation
import FunctionalSwift
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

protocol NetworkTaskAsync {
    associatedtype Body
    func perform(using: URLRequestConvertible) async throws -> URLResponseContainer<Body>

    func perform(using: URLRequestConvertible, completion: @escaping ResultClosure<URLResponseContainer<Body>>)
}
