// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

protocol RequestFactory {
    associatedtype RequestType
    func request(for type: RequestType) throws -> URLRequestConvertible
}

struct GenericNetwork<F: RequestFactory> {
    let adapter: ResponseAdapter
    let urlSession: URLSession
    let factory: F
    typealias RequestType = F.RequestType
}


extension GenericNetwork {
    func data<T>(for type: RequestType) async throws -> T where T: Decodable {
        let task = RequestDataTask(session: urlSession, responseAdapter: adapter)
        let request = try factory.request(for: type)
        return try await task.load(request: request)
    }
}
