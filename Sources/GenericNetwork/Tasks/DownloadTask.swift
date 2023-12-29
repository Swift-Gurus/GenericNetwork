import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

protocol DownloadDataTask {
    @discardableResult
    func download(request: URLRequestConvertible) async throws -> URL
}

struct DownloadDataTaskBase:  DownloadDataTask {
    private let session: URLSession
    private let responseAdapter: ResponseAdapter
    private let destinationURL: URL
    private let mover: FileMover
    init(session: URLSession, responseAdapter: ResponseAdapter,
         destinationURL: URL,
         mover: FileMover) {
        self.session = session
        self.responseAdapter = responseAdapter
        self.mover = mover
        self.destinationURL = destinationURL
    }
    
    func download(request: URLRequestConvertible) async throws -> URL {
       let urlRequest = try request.urlRequest()
       let (data, response) = try await session.download(for: urlRequest,
                                                         destination: destinationURL,
                                                         mover: mover)
       return try responseAdapter.response(for: data, response: response)
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

extension String: Error {
    var errorDescription: String? {
        self
    }
}

private func proccessDownloadResponse(response:  (url: URL?, response: URLResponse?, downloadError: Error?)) throws -> (URL, URLResponse) {
    
    if let error = response.downloadError {
        throw error
    }
    
    guard let url = response.url, let response = response.response else {
        throw "Download failed: no response or url"
    }
    
    return (url, response)
}
