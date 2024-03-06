import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

protocol DownloadDataTask {
    @discardableResult
    func download(request: URLRequestConvertible) async throws -> URLResponseContainer<URL>
}

struct DownloadDataTaskBase:  URLRequestTask {
  
    private let session: URLSession
    private let destinationURL: URL
    private let mover: FileMover
    
    init(session: URLSession,
         destinationURL: URL,
         mover: FileMover) {
        self.session = session
        self.mover = mover
        self.destinationURL = destinationURL
    }
    
    func perform(using urlRequest: URLRequest) async throws -> URLResponseContainer<URL> {
        let (data, response) = try await session.download(for: urlRequest,
                                                          destination: destinationURL,
                                                          mover: mover)
        return .init(response: response, body: data)
    }
    
}




extension String: Error {
    var errorDescription: String? {
        self
    }
}

