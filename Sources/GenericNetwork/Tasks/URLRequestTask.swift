import Foundation
import FunctionalSwift

protocol URLRequestTaskAsync {
    associatedtype Body
    func perform(using: URLRequest) async throws -> URLResponseContainer<Body>
    func perform(using: URLRequest, completion: @escaping ResultClosure<URLResponseContainer<Body>>)
}
