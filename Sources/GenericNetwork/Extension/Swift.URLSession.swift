import Foundation
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


extension URLSession {
    public func data(using request: URLRequest) async throws -> (Data, URLResponse) {
        #if canImport(FoundationNetworking)
        return try await dataForNetworkingFoundation(using: request)
        #else
        return try await data(for: request)
        #endif
    }
    
    private func dataForNetworkingFoundation(using request: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            self.dataTask(with: request) { data, response, error in
                processResponse(data: data, response: response, error: error, using: continuation)
            }.resume()
        }
    }
    
   
}
private func processResponse(data: Data?,
                             response: URLResponse?,
                             error: Error?,
                             using continuation: CheckedContinuation<(Data, URLResponse), Error>) {
    if let error {
        continuation.resume(throwing: error)
        return
    }
    
    if let data, let response {
        continuation.resume(returning: (data, response))
        return
    }
    
    continuation.resume(throwing: NoResponseNoData())
    
    
}

struct NoResponseNoData: Error {}
