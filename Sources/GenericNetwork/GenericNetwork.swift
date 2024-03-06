
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public protocol RequestFactory {
    associatedtype RequestType
    func request(for type: RequestType) throws -> URLRequestConvertible
}

public struct GenericNetwork<F: RequestFactory> {
    public var adapter:  URLContainerValidator = GenericResponseAdapter(successCodeRange: Array(200...299))
    public var urlSession: URLSession = .shared
    public var decoder: JSONDecoder = .init()
    private let factory: F
    private let fileMover: FileMover
    
    public init(urlSession: URLSession = .shared,
                factory: F,
                fileMover: FileMover? = nil) {
        self.urlSession = urlSession
        self.factory = factory
        self.fileMover = fileMover ?? FileMoverBase()
    }
    
}

public extension GenericNetwork {
    func data<T>(for type: F.RequestType) async throws -> NetworkResponse<T> where T: Decodable {
        let request = try factory.request(for: type)
        let dataTask = RequestDataTask(session: urlSession).with(validator: adapter)
                                                           .with(decoder: decoder, type: T.self)
        return try await dataTask.perform(using: request)
    }
    
}

public extension GenericNetwork {
    func download(for type: F.RequestType, destination: URL) async throws -> NetworkResponse<URL> {
        let task = DownloadDataTaskBase(session: urlSession,
                                        destinationURL: destination,
                                        mover: fileMover)
                    .with(validator: adapter)

        let request = try factory.request(for: type)
        let container = try await task.perform(using: request)
        return .init(status: container.status, body: destination)
    }
}
