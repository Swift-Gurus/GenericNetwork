import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


public protocol ResponseAdapter {
    func response<T: Decodable>(for data: Data, response: URLResponse) throws -> T
    
    func response(for url: URL, response: URLResponse) throws -> URL
}

public protocol DataDecoder {
    associatedtype Object
    func decode<Object>(data: Data) throws -> Object
}

public protocol URLContainerValidator {
    func response<T>(for container: URLResponseContainer<T>) throws -> URLResponseContainer<T>
}

struct GenericResponseAdapter: URLContainerValidator {
  
    let successCodeRange: [Int]
    
    func response<T>(for container: URLResponseContainer<T>) throws -> URLResponseContainer<T> {
        if !successCodeRange.isEmpty && 
            !successCodeRange.contains(container.response.responseCode) {
            throw NetworkResponse(status: container.status, body: container.body)
        }
        
        return container
    }
}



public func defaultResponseAdapter() ->  URLContainerValidator {
    GenericResponseAdapter(successCodeRange: Array(200...299))
}


public struct GenericNetworkError<T>: Error {
    public let body: T
    public let code: Int
}
