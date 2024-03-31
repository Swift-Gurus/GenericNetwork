import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Generic response container
public struct URLResponseContainer<T> {
    /// Response status code. Includes http codes and hardwared
    public var status: Int { networkResponse.status }

    /// Generic body
    public var body: T { networkResponse.body }

    /// Network response container
    public let networkResponse: NetworkResponse<T>

    /// URLResponse
    public let response: URLResponse

    init(response: URLResponse, body: T) {
        self.response = response
        networkResponse = .init(status: response.responseCode, body: body)
    }
}

/// Network response container
public struct NetworkResponse<T> {
    /// Response status code. Includes http codes and hardwared
    public let status: Int

    /// Generic body
    public let body: T
}

extension URLResponse {
    var responseCode: Int {
        guard let httpResponse = self as? HTTPURLResponse else {
            return -1
        }
        return httpResponse.statusCode
    }
}

extension URLResponseContainer: Error  where T == Data {}

extension URLResponseContainer: Equatable where T: Equatable {}

extension URLResponseContainer: Sendable where T: Sendable {}

extension NetworkResponse: Equatable where T: Equatable {}
extension NetworkResponse: Sendable where T: Sendable {}
