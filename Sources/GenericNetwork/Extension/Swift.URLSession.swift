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


extension URLSession {
     func download(for request: URLRequest, destination: URL, mover: FileMover) async throws -> (URL, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            downloadTask(with: request) {
                do {
                    let pair = try proccessDownloadResponse(response: ($0, $1, $2))
                    try mover.move(from: pair.0, to: destination)
                    continuation.resume(returning: pair)
                } catch {
                    continuation.resume(throwing: error)
                }
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


private func proccessDownloadResponse(response:  (url: URL?, response: URLResponse?, downloadError: Error?)) throws -> (URL, URLResponse) {
    
    if let error = response.downloadError {
        throw error
    }
    
    guard let url = response.url, let response = response.response else {
        throw "Download failed: no response or url"
    }
    
    return (url, response)
}
