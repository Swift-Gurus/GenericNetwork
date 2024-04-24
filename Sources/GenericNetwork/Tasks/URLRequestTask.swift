import Foundation
import FunctionalSwift
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

protocol URLRequestTaskAsync {
    associatedtype Body
    func perform(using: URLRequest) async throws -> URLResponseContainer<Body>
    func perform(using: URLRequest, completion: @escaping ResultClosure<URLResponseContainer<Body>>)
}
