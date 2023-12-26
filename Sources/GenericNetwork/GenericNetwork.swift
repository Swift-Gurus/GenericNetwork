
import Foundation

public protocol RequestFactory {
    associatedtype RequestType
    func request(for type: RequestType) throws -> URLRequestConvertible
}
public struct GenericNetwork<F: RequestFactory> {
    private let adapter: ResponseAdapter
    private let urlSession: URLSession
    private let factory: F
    private let fileMover: FileMover = FileMoverBase()
    public typealias RequestType = F.RequestType

    public init(adapter: ResponseAdapter = DefaultResponseAdapter(),
                urlSession: URLSession = .shared,
                factory: F) {
        self.adapter = adapter
        self.urlSession = urlSession
        self.factory = factory
    }
}


public extension GenericNetwork {
    func data<T>(for type: RequestType) async throws -> T where T: Decodable {
        let task = RequestDataTask(session: urlSession, responseAdapter: adapter)
        let request = try factory.request(for: type)
        return try await task.load(request: request)
    }
}


public extension GenericNetwork {
    func download(for type: RequestType, destination: URL) async throws {
        let task: DownloadDataTask = DownloadDataTaskBase(session: urlSession,
                                                          responseAdapter: adapter,
                                                          destinationURL: destination,
                                                          mover: fileMover)

        let request = try factory.request(for: type)
        try await task.download(request: request)
    }
}
