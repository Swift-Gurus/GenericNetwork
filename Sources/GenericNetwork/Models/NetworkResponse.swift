import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


public struct URLResponseContainer<T> {
    var status: Int {
        response.responseCode
    }
    let response: URLResponse
    let body: T
    
    init(response: URLResponse, body: T) {
        self.response = response
        self.body = body
    }
}

public struct NetworkResponse<T> {
    public let status: Int
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


extension NetworkResponse: Error {
    
}
