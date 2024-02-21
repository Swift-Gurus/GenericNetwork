import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


public protocol ResponseAdapter {
    func response<T: Decodable>(for data: Data, response: URLResponse) throws -> T
    
    func response(for url: URL, response: URLResponse) throws -> URL
}

struct GenericResponseAdapter: ResponseAdapter {
    
    let successCodeRange: [Int]
    private let decoder = JSONDecoder()
    
    func response<T: Decodable>(for data: Data, response: URLResponse) throws -> T {
        try validate(response: response, for: data)
        return try decoder.decode(T.self, from: data)
    }
    
    func response(for url: URL, response: URLResponse) throws -> URL {
        try validate(response: response, for: url)
        return url
    }
    
    private func validate<T>(response: URLResponse, for data: T) throws {
        if let httpResponse = response as? HTTPURLResponse,
           !successCodeRange.isEmpty && !successCodeRange.contains(httpResponse.statusCode) {
            throw GenericNetworkError(body: data, code: httpResponse.statusCode)
        }
    }
}



public func defaultResponseAdapter() -> ResponseAdapter {
    GenericResponseAdapter(successCodeRange: Array(200...299))
}


public struct GenericNetworkError<T>: Error {
    public let body: T
    public let code: Int
}
