import Foundation
import FunctionalSwift
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

protocol DownloadDataTaskAsync {
    @discardableResult
    func download(request: URLRequestConvertible) async throws -> URLResponseContainer<URL>
}

struct DownloadDataTaskBase: URLRequestTaskAsync {
    private let session: URLSession
    private let destinationURL: URL
    private let mover: FileMover
    private let responseAdapter = GenericResponseAdapter<URL>()

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

    func perform(using urlRequest: URLRequest,
                 completion: @escaping ResultClosure<URLResponseContainer<URL>>) {
        session.downloadTask(with: urlRequest) { [responseAdapter, mover, destinationURL] url, response, error in
            responseAdapter.getResponse(data: url, response: response, error: error, originalRequest: urlRequest)
                           .doTry { try mover.move(from: $0.body, to: destinationURL) }
                           .map { .init(response: $0.response, body: destinationURL) }
                           .sink(completion)
        }
        .resume()
    }
}
